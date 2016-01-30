message( "External project - VTK" )

find_package(Git)
if(NOT GIT_FOUND)
  message(ERROR "Cannot find git. git is required for Superbuild")
endif()

option( USE_GIT_PROTOCOL "If behind a firewall turn this off to use http instead." ON)

set(git_protocol "git")
if(NOT USE_GIT_PROTOCOL)
  set(git_protocol "http")
endif()

set( VTK_DEPENDENCIES )

if( ${USE_SYSTEM_HDF5} MATCHES "OFF" )
  set( VTK_DEPENDENCIES HDF5 )
endif()

set( _vtkOptions )
if( APPLE )
  set( _vtkOptions -DVTK_REQUIRED_OBJCXX_FLAGS:STRING="" )
endif()

option( BUILD_VTK_RENDERING "Build vtk rendering (disable if opengl not present" ON)
#http://www.vtk.org/pipermail/vtkusers/2015-May/090922.html
if(NOT BUILD_VTK_RENDERING)
  set( _vtkNoRendering -DVTK_Group_StandAlone:BOOL=OFF 
	-DVTK_Group_Rendering:BOOL=OFF 
	-DModule_vtkCommonComputationalGeometry:BOOL=ON 
	-DModule_vtkCommonDataModel:BOOL=ON 
	-DModule_vtkCommonExecutionModel:BOOL=ON 
	-DModule_vtkCommonMath:BOOL=ON 
	-DModule_vtkCommonMisc:BOOL=ON 
	-DModule_vtkCommonSystem:BOOL=ON 
	-DModule_vtkCommonTransforms:BOOL=ON 
	-DModule_vtkFiltersCore:BOOL=ON 
	-DModule_vtkFiltersExtraction:BOOL=ON 
	-DModule_vtkFiltersGeneral:BOOL=ON 
	-DModule_vtkFiltersGeneric:BOOL=ON 
	-DModule_vtkFiltersGeometry:BOOL=ON 
	-DModule_vtkFiltersPython:BOOL=OFF
	-DModule_vtkIOCore:BOOL=ON 
	-DModule_vtkIOGeometry:BOOL=ON 
	-DModule_vtkIOLegacy:BOOL=ON 
	-DModule_vtkWrappingPythonCore:BOOL=OFF)
endif()

ExternalProject_Add(VTK
  DEPENDS ${VTK_DEPENDENCIES}
  GIT_REPOSITORY ${git_protocol}://vtk.org/VTK.git
  GIT_TAG v6.1.0
  SOURCE_DIR VTK
  BINARY_DIR VTK-build
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CMAKE_GENERATOR ${EP_CMAKE_GENERATOR}
  CMAKE_ARGS
    ${ep_common_args}
    ${_vtkOptions}
    ${cmake_hdf5_libs}
    ${_vtkNoRendering}
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_BUILD_TYPE:STRING=${BUILD_TYPE}
    -DVTK_BUILD_ALL_MODULES:BOOL=OFF
    -DVTK_USE_SYSTEM_HDF5:BOOL=ON
    -DHDF5_DIR:PATH=${HDF5_DIR}
    -DCMAKE_INSTALL_PREFIX:PATH=${INSTALL_DEPENDENCIES_DIR}
)

set( VTK_DIR ${INSTALL_DEPENDENCIES_DIR}/lib/cmake/vtk-6.1/ )
