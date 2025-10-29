# GLFW, GLAD, CGLM & SOKOL Project Setup Script

This script automates the setup of a new project using GLFW and GLAD on macOS. It creates a basic structure for an OpenGL project, allowing you to quickly start coding with GLFW GLAD, CGLM and SOKOL and generates necessary source files, a Makefile, and a default project structure.

![Project Demo](Images/Demo.png)

## Prerequisites

Before running the script, ensure you have the following tools installed:

1. **Homebrew**: A package manager for macOS.  
   - Install it by following the [Homebrew installation guide](https://brew.sh/).

2. **GLFW**: A library for creating windows with OpenGL contexts and managing input.  
   - The script automatically checks and installs GLFW via Homebrew if it's not already installed.

3. **GLAD**: An OpenGL loader that handles the loading of OpenGL extensions.  
   - The script assumes GLAD is downloaded and placed in the `Downloads` folder.

4. **Bear** (optional but recommended if using Neovim): A tool that generates `compile_commands.json` for better LSP support with libraries like GLFW and OpenGL.  
   - Install it by running:  
     ```bash
     $ brew install bear
     ```

5. **gcc/g++/clang**: C/C++ compiler

6. **make**

## Features

- **GLFW Installation**: The script checks if GLFW is installed using Homebrew. If it's not installed, it installs it automatically.

- **GLAD Check**: The script checks if GLAD exists in the `Downloads` folder. If not, it prompts you to download and place GLAD in the folder.

- **Project Structure**:  
  - Creates a new project directory with the following subdirectories:  
    - `src/`: Contains source files.  
    - `build/`: Contains build output.  
    - `include/`: Contains header files.  
    - `lib/`: Contains library files.

- **Source File Creation**:  
  - Prompts you to select between C or C++ for your project language.  
  - Creates a `main.c` or `main.cpp` file depending on your choice, with default OpenGL setup code.  

    ⚠️ *C++ Support is not working properly, there are linking errors with GLAD* ⚠️ **Will be fixed soon**

- **Makefile Generation**:  
  - Automatically creates a Makefile that compiles the project using `gcc` or `g++` based on your language choice.  
  - Includes necessary flags for GLFW and GLAD.  
  - Supports building, cleaning, and running the project with the `make` command.

- **GLFW & GLAD Integration**: The script sets up GLFW and GLAD for use in your project, ensuring that the necessary include paths and libraries are correctly configured.

## New Features

- **Sokol Support**: Added support for integrating the lightweight Sokol libraries for graphics, audio, and more.

- **cglm Support**: Added integration with the `cglm` math library for easier vector and matrix operations in C.

- **Interactive Setup**: Added prompts for custom project names and paths during setup.

- **Verbose Logging**: The script now provides detailed logging during installation and project creation.

- **Error Handling**: Added robust error handling for missing dependencies and incorrect paths.

- **Custom Library Path**: Allows you to specify a custom path for GLFW and GLAD libraries if they are installed outside default locations.

- **Automatic `compile_commands.json` Generation**: If `Bear` is installed, the script automatically generates `compile_commands.json` for better LSP support in editors like Neovim and VSCode.

- **Default Shader Files**: Generates basic vertex and fragment shader files for quick setup.

## Usage

1. Clone or download this repository.
2. Ensure that **Homebrew** and **GLFW** are installed.
3. Download **GLAD** from [glad.dav1d.de](https://glad.dav1d.de/) and place it in your `Downloads` folder.
4. Ensure **Bear** is installed if you're using Neovim for better LSP support.
5. Run the script:

   ```bash
   $ chmod +x openglAppleSilicon.sh
   $ ./openglAppleSilicon.sh
