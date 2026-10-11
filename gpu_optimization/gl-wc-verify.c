/*
 * Check that the GPU reads exactly what the CPU wrote into GTT buffers
 * (WC-mapped on SN2 with the TTM change), with no extra fencing beyond
 * what Mesa does: CPU writes, GPU copies the buffer into a VRAM-only
 * buffer, CPU reads the result back and compares.
 *
 *   gcc -O2 -o gl-wc-verify gl-wc-verify.c -lEGL -lGL
 *   ./gl-wc-verify [iterations, default 20000]
 */
#define GL_GLEXT_PROTOTYPES 1
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GL/glcorearb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N (4 << 20)

static unsigned int seed = 12345;
static unsigned int rnd(void) { seed = seed * 1103515245 + 12345; return seed >> 8; }

int main(int argc, char **argv)
{
    int iters = argc > 1 ? atoi(argv[1]) : 20000, bad = 0;
    PFNEGLGETPLATFORMDISPLAYEXTPROC getdpy =
        (PFNEGLGETPLATFORMDISPLAYEXTPROC)eglGetProcAddress("eglGetPlatformDisplayEXT");
    EGLDisplay d = getdpy(EGL_PLATFORM_SURFACELESS_MESA, EGL_DEFAULT_DISPLAY, NULL);
    eglInitialize(d, NULL, NULL);
    eglBindAPI(EGL_OPENGL_API);
    EGLint ca[] = { EGL_CONTEXT_MAJOR_VERSION, 4, EGL_CONTEXT_MINOR_VERSION, 5,
                    EGL_CONTEXT_OPENGL_PROFILE_MASK, EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT, EGL_NONE };
    EGLContext c = eglCreateContext(d, EGL_NO_CONFIG_KHR, EGL_NO_CONTEXT, ca);
    if (!c || !eglMakeCurrent(d, EGL_NO_SURFACE, EGL_NO_SURFACE, c)) { fprintf(stderr, "no ctx\n"); return 1; }

    unsigned char *src = malloc(N), *dst = malloc(N);
    GLuint b[3];
    GLbitfield fl = GL_MAP_WRITE_BIT | GL_MAP_PERSISTENT_BIT | GL_MAP_COHERENT_BIT;
    glCreateBuffers(3, b);
    glNamedBufferStorage(b[0], N, NULL, fl | GL_CLIENT_STORAGE_BIT);   /* GTT, CPU-mapped */
    glNamedBufferData(b[1], N, NULL, GL_DYNAMIC_DRAW);                  /* BufferSubData path */
    glNamedBufferStorage(b[2], N, NULL, 0);                             /* VRAM, GPU only */
    unsigned char *m = glMapNamedBufferRange(b[0], 0, N, fl);
    if (!m) { fprintf(stderr, "map failed\n"); return 1; }

    for (int it = 0; it < iters; it++) {
        int full = it % 500 == 0;
        size_t off = full ? 0 : rnd() % (N - 4096), len = full ? N : 1 + rnd() % 3000;
        int path = it & 1;
        for (size_t i = 0; i < len; i++)
            src[i] = rnd();
        if (path == 0)
            memcpy(m + off, src, len);          /* persistent coherent map: no flush needed */
        else
            glNamedBufferSubData(b[1], off, len, src);
        glCopyNamedBufferSubData(b[path], b[2], off, off, len);
        glGetNamedBufferSubData(b[2], off, len, dst);
        if (memcmp(dst, src, len)) {
            size_t i = 0;
            while (dst[i] == src[i]) i++;
            if (bad++ < 20)
                printf("MISMATCH it=%d path=%s off=%zu len=%zu first bad byte %zu: got %02x want %02x\n",
                       it, path ? "subdata" : "map", off, len, i, dst[i], src[i]);
        }
    }
    printf("%s | %d iterations, %d mismatches\n", glGetString(GL_RENDERER), iters, bad);
    return bad != 0;
}
