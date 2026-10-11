/*
 * Measure CPU -> GPU buffer upload bandwidth the way Minecraft 26.3 uploads vertex data:
 * glNamedBufferSubData, and memcpy into a persistently mapped buffer. Headless: EGL surfaceless
 * context, so it runs alongside an X session without touching it.
 *
 *   gcc -O2 -o gpu-upload-bench gpu-upload-bench.c -lEGL -lGL
 *   ./gpu-upload-bench [MiB per pass, default 32]
 *
 * The plain-RAM memcpy line is the CPU baseline; the GPU lines are what the bus and the mapping
 * attributes allow.
 */
#define GL_GLEXT_PROTOTYPES 1
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GL/glcorearb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static double now(void) {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec * 1e-9;
}

static void report(const char *what, double bytes, double secs) {
    printf("%-46s %8.1f MB/s\n", what, bytes / secs / 1e6);
}

int main(int argc, char **argv) {
    size_t mib = argc > 1 ? strtoul(argv[1], 0, 10) : 32, n = mib << 20;
    int passes = 8;

    PFNEGLGETPLATFORMDISPLAYEXTPROC getdpy =
        (PFNEGLGETPLATFORMDISPLAYEXTPROC)eglGetProcAddress("eglGetPlatformDisplayEXT");
    EGLDisplay d = getdpy(EGL_PLATFORM_SURFACELESS_MESA, EGL_DEFAULT_DISPLAY, NULL);
    if (!eglInitialize(d, NULL, NULL)) { fprintf(stderr, "eglInitialize failed\n"); return 1; }
    eglBindAPI(EGL_OPENGL_API);
    EGLint ca[] = { EGL_CONTEXT_MAJOR_VERSION, 4, EGL_CONTEXT_MINOR_VERSION, 5,
                    EGL_CONTEXT_OPENGL_PROFILE_MASK, EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT, EGL_NONE };
    EGLContext c = eglCreateContext(d, EGL_NO_CONFIG_KHR, EGL_NO_CONTEXT, ca);
    if (!c || !eglMakeCurrent(d, EGL_NO_SURFACE, EGL_NO_SURFACE, c)) {
        fprintf(stderr, "no GL 4.5 core context\n"); return 1;
    }
    printf("%s | %s | %zu MiB x %d passes\n",
           glGetString(GL_RENDERER), glGetString(GL_VERSION), mib, passes);

    char *src = malloc(n), *dst = malloc(n);
    memset(src, 0x5a, n); memset(dst, 0, n);
    double t = now();
    for (int i = 0; i < passes; i++) memcpy(dst, src, n);
    report("memcpy RAM -> RAM (CPU baseline)", (double)n * passes, now() - t);

    GLuint b[3];
    glCreateBuffers(3, b);

    /* 1. glNamedBufferSubData into a DYNAMIC_DRAW buffer (Minecraft's nglNamedBufferSubData). */
    glNamedBufferData(b[0], n, NULL, GL_DYNAMIC_DRAW);
    glFinish();
    t = now();
    for (int i = 0; i < passes; i++) glNamedBufferSubData(b[0], 0, n, src);
    glFinish();
    report("glNamedBufferSubData (DYNAMIC_DRAW)", (double)n * passes, now() - t);

    /* 2./3. memcpy into a persistent, coherent mapping (Minecraft's mapped staging buffers),
     * without and with GL_CLIENT_STORAGE_BIT (which asks for system memory, not VRAM). */
    GLbitfield fl = GL_MAP_WRITE_BIT | GL_MAP_PERSISTENT_BIT | GL_MAP_COHERENT_BIT;
    const char *names[2] = { "memcpy -> persistent coherent mapping",
                             "memcpy -> same, GL_CLIENT_STORAGE_BIT" };
    for (int k = 0; k < 2; k++) {
        glNamedBufferStorage(b[1 + k], n, NULL, fl | (k ? GL_CLIENT_STORAGE_BIT : 0));
        char *m = glMapNamedBufferRange(b[1 + k], 0, n, fl);
        if (!m) { printf("%-46s map failed\n", names[k]); continue; }
        memcpy(m, src, n);  /* first touch outside the timing */
        glFinish();
        t = now();
        for (int i = 0; i < passes; i++) memcpy(m, src, n);
        glFinish();
        report(names[k], (double)n * passes, now() - t);
        glUnmapNamedBuffer(b[1 + k]);
    }
    return 0;
}
