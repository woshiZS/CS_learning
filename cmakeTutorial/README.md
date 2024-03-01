关于target_include_directories，有三个选项PULIC, PRIVATE以及INTERFACE，主要和依赖的target相关

| Include Inheritance | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| `PUBLIC`            | All the directories following `PUBLIC` will be used for the current target and the other targets that have dependencies on the current target, i.e., appending the directories to `INCLUDE_DIRECTORIES` and `INTERFACE_INCLUDE_DIRECTORIES`. |
| `PRIVATE`           | All the include directories following `PRIVATE` will be used for the current target only, i.e., appending the directories to `INCLUDE_DIRECTORIES`. |
| `INTERFACE`         | All the include directories following `INTERFACE` will NOT be used for the current target but will be accessible for the other targets that have dependencies on the current target, i.e., appending the directories to `INTERFACE_INCLUDE_DIRECTORIES`. |

同理target_link_library与之类似。

* add_subdirectory相当于在总目录下新建了一个子目录，然后再子目录下添加一个新的CMakeLists.txt