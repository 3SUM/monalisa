cmake_minimum_required(VERSION 3.7)
project(main)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")


add_executable(main main.cpp hashMap.hpp) 

