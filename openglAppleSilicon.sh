#!/bin/bash

check_glfw() {
    if brew list glfw &>/dev/null; then
        echo -e "\033[32m[✔] GLFW is already installed.\033[0m"
    else
        echo -e "\033[31m[✘] GLFW not found. Installing GLFW via Homebrew...\033[0m"
        brew install glfw
        echo -e "\033[32m[✔] GLFW installed.\033[0m"
    fi

    GLFW_INCLUDE_DIR="$(brew --prefix glfw)/include"
    GLFW_LIB_DIR="$(brew --prefix glfw)/lib"

    echo -e "\033[32m[✔] GLFW include directory: $GLFW_INCLUDE_DIR\033[0m"
    echo -e "\033[32m[✔] GLFW library directory: $GLFW_LIB_DIR\033[0m"
}

check_glad() {
    if [ -d "~/Downloads/glad" ] || [ -d "$HOME/Downloads/glad" ]; then
        echo -e "\033[32m[✔] GLAD found in Downloads folder.\033[0m"
    else
        echo -e "\033[31m[✘] GLAD not found. Please download GLAD from https://glad.dav1d.de/ and place it in your Downloads folder.\033[0m"
        exit 1
    fi
}
check_cglm() {
    if brew list cglm &>/dev/null; then
        echo -e "\033[32m[✔] cglm is already installed.\033[0m"
    else
        echo -e "\033[31m[✘] cglm not found. Installing cglm via Homebrew...\033[0m"
        brew install cglm
        echo -e "\033[32m[✔] cglm installed.\033[0m"
    fi

    CGLM_INCLUDE_DIR="$(brew --prefix cglm)/include/cglm/include/cglm/"
    echo -e "\033[32m[✔] cglm include directory: $CGLM_INCLUDE_DIR\033[0m"
}

check_sokol() {
    if [ ! -d "$HOME/sokol" ]; then
        echo -e "\033[31m[✘] Sokol not found. Cloning Sokol repository...\033[0m"
        git clone https://github.com/floooh/sokol.git $HOME/sokol
        echo -e "\033[32m[✔] Sokol cloned to $HOME/sokol.\033[0m"
    else
        echo -e "\033[32m[✔] Sokol is already installed.\033[0m"
    fi

    # Set the path for Sokol include files
    SOKOL_INCLUDE_DIR="$HOME/sokol/"
    echo -e "\033[32m[✔] Sokol include directory: $SOKOL_INCLUDE_DIR\033[0m"
}

setup_project() {
    echo " "
    read -p "Enter project name: " project_name
    echo " "

    mkdir -p "$project_name"/{src,build,include,lib}
    echo -e "\033[32m[✔] Project directories created.\033[0m"

    cp -r ~/Downloads/glad/include/* "$project_name/include/"
    cp ~/Downloads/glad/src/glad.c "$project_name/src/"
    echo -e "\033[32m[✔] GLAD files copied to project.\033[0m"

    cp -r "$(brew --prefix cglm)/include/cglm" "$project_name/include/"
    echo -e "\033[32m[✔] cglm files copied to project.\033[0m"

    # Copy Sokol headers to the project
    cp -r $SOKOL_INCLUDE_DIR/* "$project_name/include/"
    echo -e "\033[32m[✔] Sokol headers copied to project.\033[0m"

    # Prompt for language (C or C++)
    echo " "
    echo -e "Select Language: C[1] or C++[2]"
    read -p "Enter your choice: " lang_choice
    echo " "

    if [[ "$lang_choice" == "1" ]]; then
        echo "You chose C"
        src_file="main.c"
        compile_cmd="gcc"
        extension="c"
    elif [[ "$lang_choice" == "2" ]]; then
        echo "You chose C++"
        src_file="main.cpp"
        compile_cmd="g++"
        extension="cpp"
    else
        echo -e "\033[31m[✘] Invalid choice, defaulting to C.\033[0m"
        src_file="main.c"
        compile_cmd="gcc"
        extension="c"
    fi

    # Create main source file
    cat > "$project_name/src/$src_file" <<EOL
#define UNUSED __attribute__((unused))

#define OPENG_INCLUDES
#include <glad/glad.h>
#include <GLFW/glfw3.h>

#define CGLM_INCLUDE
#include <cglm/cglm.h>

#define SOKOL_INCLUDE
#include <sokol_gfx.h>  

#include <stdio.h>
#include <stdlib.h>

static void framebuffer_size_callback(UNUSED GLFWwindow* window, int width, int height)
{
    glViewport(0, 0, width, height);
}

static GLFWwindow* init(void)
{
    if (!glfwInit()) {
        fprintf(stderr, "GLFW initialization failed\n");
        return NULL;
    }
    
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3); 
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
#if __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

    GLFWwindow* window = glfwCreateWindow(1280, 720, "Renderer", NULL, NULL);
    if (!window) {
        fprintf(stderr, "GLFW window creation failed\n");
        glfwTerminate();
        return NULL;
    }
    
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1); 

    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        fprintf(stderr, "Failed to initialize GLAD\n");
        return NULL;
    }

    const char *version = (const char *)glGetString(GL_VERSION);
    printf("OpenGL version: %s\n", version);

    return window;
}

int main(UNUSED int argc, UNUSED char **argv)
{
    GLFWwindow* window = init();
    if (!window) {
        return EXIT_FAILURE;
    }

    glViewport(0, 0, 800, 600);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    while (!glfwWindowShouldClose(window)) {
        glClear(GL_COLOR_BUFFER_BIT);
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    glfwTerminate();
    return EXIT_SUCCESS;
}
EOL
    echo -e "\033[32m[✔] main.$extension created.\033[0m"

    # Create Makefile
    if [[ "$lang_choice" == "2" ]]; then
        cp ./Makefile_cpp "$project_name/Makefile"
    else
        cp ./Makefile_c "$project_name/Makefile"
    fi
    echo -e "\033[32m[✔] Makefile created.\033[0m"
}

check_glfw
check_glad
check_cglm
check_sokol
setup_project

echo -e "\033[32m[✔] Project setup complete!\033[0m"

