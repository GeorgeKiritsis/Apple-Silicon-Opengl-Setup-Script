PROJECT_NAME := Demo

SRC_DIR := src
BUILD_DIR := build
INCLUDE_DIR := include

GLFW_INCLUDE_DIR := /opt/homebrew/opt/glfw/include
GLFW_LIB_DIR := /opt/homebrew/opt/glfw/lib
CGLM_INCLUDE_DIR := /opt/homebrew/opt/cglm/include/cglm
SOKOL_INCLUDE_DIR := /Users/giorgoskir/sokol/include  

CC := gcc
CFLAGS := -Wall -Wextra -std=c99 -I$(INCLUDE_DIR) -I$(GLFW_INCLUDE_DIR) -I$(SOKOL_INCLUDE_DIR) 
LDFLAGS := -L$(GLFW_LIB_DIR) -lglfw -ldl -framework OpenGL -framework Cocoa

SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))

all: $(BUILD_DIR)/$(PROJECT_NAME)

$(BUILD_DIR)/$(PROJECT_NAME): $(OBJS)
	mkdir -p $(BUILD_DIR)
	$(CC) $(OBJS) -o $(BUILD_DIR)/$(PROJECT_NAME) $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)

exec: $(BUILD_DIR)/$(PROJECT_NAME)
	./$(BUILD_DIR)/$(PROJECT_NAME)

.PHONY: all clean exec

