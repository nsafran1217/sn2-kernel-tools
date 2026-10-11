#!/bin/sh
# glmark2-drm subset: vertex upload (build), texture, buffer map/subdata updates
exec glmark2-drm \
 -b build:use-vbo=false -b build:use-vbo=true \
 -b texture:texture-filter=linear \
 -b buffer:update-fraction=0.5:update-dispersion=0.9:columns=200:update-method=map:interleave=false \
 -b buffer:update-fraction=0.5:update-dispersion=0.9:columns=200:update-method=subdata:interleave=false \
 -b buffer:update-fraction=0.5:update-dispersion=0.9:columns=200:update-method=map:interleave=true \
 -b shading:shading=phong -b terrain 2>&1 | grep -vE "^\s*$"
