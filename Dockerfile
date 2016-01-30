FROM insighttoolkit/itk-base

RUN mkdir -p /home/itk/src/statismo  && mkdir -p /home/itk/build/statismo

COPY scripts  /home/itk/src/statismo/scripts  
COPY cmake /home/itk/src/statismo/cmake
COPY modules /home/itk/src/statismo/modules
COPY superbuild /home/itk/src/statismo/superbuild
COPY *.txt *.in /home/itk/src/statismo/ 

WORKDIR /home/itk/build/statismo
RUN cmake \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DMINIMAL_STATISMO_BUILD:BOOL=ON \
    -DBUILD_VTK_RENDERING:BOOL=OFF \
    /home/itk/src/statismo/superbuild/ 

#create a  layer for every target 

RUN make -j$(grep -c processor /proc/cpuinfo) Eigen3
RUN make -j$(grep -c processor /proc/cpuinfo) Boost
RUN make -j$(grep -c processor /proc/cpuinfo) HDF5
RUN make -j$(grep -c processor /proc/cpuinfo) VTK
RUN make -j$(grep -c processor /proc/cpuinfo) ITK

#try to build everything just to be sure
RUN make -j$(grep -c processor /proc/cpuinfo) 