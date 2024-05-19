#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <math.h> 
#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include "LinkedList.h"
#include "Objects.h"

//one-time serialization of constant variables
void oneoffSerialize(GLuint program)
{
    //background color
    glUniform4f(glGetUniformLocation(program, "MainColor"), 0.075, 0.133, 0.173, 1.0);
    //optimizations
    glUniform1i(glGetUniformLocation(program, "MaxIter"), 100);
    glUniform1f(glGetUniformLocation(program, "Tolerance"), 0.001);
    //main light source
    glUniform3f(glGetUniformLocation(program, "LightDir"), 0.0, -1.0, 0.8);
    glUniform4f(glGetUniformLocation(program, "LightColor"), 1.0, 1.0, 1.0, 0.0);
    glUniform1f(glGetUniformLocation(program, "LightIntensity"), 3.0);
    //shading
    glUniform1f(glGetUniformLocation(program, "ShadowIntensity"), 1.0);
    glUniform1f(glGetUniformLocation(program, "ShadowSoftness"), 0.25);
    glUniform2f(glGetUniformLocation(program, "ShadowDistance"), 0.0, 25.0);

}

//globalSerialization
template <typename T>
void globalSerialize(GLuint program, List<MarchingObject<T>>& scene)
{
    int size = scene.size();
    //the highest number of data is vect4, thats why * 4
    T* serializer = new T[size * 4];
    //for intigers
    GLint* iserializer = new GLint[size];

    glUniform1i(glGetUniformLocation(program, "ObjectsCap"), size);

    //for every object
    int index = 0;
    //position
    for (auto& i : scene)
    {
        serializer[index] = i.data.pos.x;
        //std::cout << serializer[index] << std::endl;
        ++index;
        serializer[index] = i.data.pos.y;
        //std::cout << serializer[index] << std::endl;
        ++index;
        serializer[index] = i.data.pos.z;
        //std::cout << serializer[index] << std::endl;
        ++index;
    }
    //std::cout << glGetUniformLocation(program, "ShapePosition") << std::endl;
    glUniform3fv(glGetUniformLocation(program, "ShapePosition"), size, serializer);

    //rotation:
    index = 0;
    for (auto& i : scene)
    {
        serializer[index] = i.data.rot.x;
        ++index;
        serializer[index] = i.data.rot.y;
        ++index;
        serializer[index] = i.data.rot.z;
        ++index;
    }
    glUniform3fv(glGetUniformLocation(program, "ShapeRotation"), size, serializer);

    //scale
    index = 0;
    for (auto& i : scene)
    {
        serializer[index] = i.data.scale.x;
        ++index;
        serializer[index] = i.data.scale.y;
        ++index;
        serializer[index] = i.data.scale.z;
        ++index;
        serializer[index] = i.data.scale.w;
        ++index;
    }
    //std::cout << glGetUniformLocation(program, "ShapeScale") << std::endl;
    glUniform4fv(glGetUniformLocation(program, "ShapeScale"), size, serializer);

    //shapeType
    index = 0;
    for (auto& i : scene)
    {
        iserializer[index] = i.data.shapeType;
        ++index;
    }
    glUniform1iv(glGetUniformLocation(program, "ShapeType"), size, iserializer);

    //connectType
    index = 0;
    for (auto& i : scene)
    {
        iserializer[index] = i.data.connectType;
        ++index;
    }
    glUniform1iv(glGetUniformLocation(program, "ConnectType"), size, iserializer);

    //connectFactor
    index = 0;
    for (auto& i : scene)
    {
        serializer[index] = i.data.connectFactor;
        ++index;
    }
    //std::cout << glGetUniformLocation(program, "ConnectFactor") << std::endl;
    glUniform1fv(glGetUniformLocation(program, "ConnectFactor"), size, serializer);

    //textures:

    //tex type
    index = 0;
    for (auto& i : scene)
    {
        iserializer[index] = i.data.texType;
        ++index;
    }
    //std::cout << glGetUniformLocation(program, "TextureType") << std::endl;
    glUniform1iv(glGetUniformLocation(program, "TextureType"), size, iserializer);

    //tex color
    index = 0;
    for (auto& i : scene)
    {
        serializer[index] = i.data.texColor.x;
        ++index;
        serializer[index] = i.data.texColor.y;
        ++index;
        serializer[index] = i.data.texColor.z;
        ++index;
        serializer[index] = i.data.texColor.w;
        ++index;
    }
    //std::cout << glGetUniformLocation(program, "TextureColor") << std::endl;
    glUniform4fv(glGetUniformLocation(program, "TextureColor"), size, serializer);

    //tex scale
    index = 0;
    for (auto& i : scene)
    {
        serializer[index] = i.data.texScale.x;
        ++index;
        serializer[index] = i.data.texScale.y;
        ++index;
        serializer[index] = i.data.texScale.z;
        ++index;
        serializer[index] = i.data.texScale.w;
        ++index;
    }
    //std::cout << glGetUniformLocation(program, "ShapeScale") << std::endl;
    glUniform4fv(glGetUniformLocation(program, "TextureScale"), size, serializer);

    delete serializer;
    delete iserializer;
}

//data for whole window showcase
GLfloat vertices[] =
{
    -1.0f, -1.0f , 0.0f, 0.0f, 0.0f,
    -1.0f,  1.0f , 0.0f, 0.0f, 1.0f,
     1.0f,  1.0f , 0.0f, 1.0f, 1.0f,
     1.0f, -1.0f , 0.0f, 1.0f, 0.0f,
};

GLuint indices[] =
{
    0, 2, 1,
    0, 3, 2
};

//also basic shaders for that:
const char* screenVertexShaderSource = R"(#version 460 core
layout (location = 0) in vec3 pos;
layout (location = 1) in vec2 uvs;
out vec2 UVs;
void main()
{
	gl_Position = vec4(pos.x, pos.y, pos.z, 1.0);
	UVs = uvs;
})";
const char* screenFragmentShaderSource = R"(#version 460 core
out vec4 FragColor;
uniform sampler2D screen;
in vec2 UVs;
void main()
{
	FragColor = texture(screen, UVs);
})";

//shaderCreation
static unsigned int CompileShader(const std::string& source, unsigned int type)
{
    unsigned int id = glCreateShader(type);
    const char* src = source.c_str();
    glShaderSource(id, 1, &src, nullptr);
    glCompileShader(id);

    int result;
    glGetShaderiv(id, GL_COMPILE_STATUS, &result);

    if (result == GL_FALSE)
    {
        std::cout << "failed to compile shader" << std::endl;
        glDeleteShader(id);
        return 0;
    }

    return id;
}

static int CreateClassicShader(const std::string& vertShader, const std::string& fragShader)
{
    unsigned int program = glCreateProgram();
    unsigned int vert = CompileShader(vertShader, GL_VERTEX_SHADER);
    unsigned int frag = CompileShader(fragShader, GL_FRAGMENT_SHADER);

    glAttachShader(program, vert);
    glAttachShader(program, frag);
    glLinkProgram(program);
    glValidateProgram(program);

    glDeleteShader(vert);
    glDeleteShader(frag);

    return program;
}

static GLuint CreateComputeShader(const char* source)
{
    
    GLuint computeShader = glCreateShader(0x91B9);
    glShaderSource(computeShader, 1, &source, NULL);
    glCompileShader(computeShader);

    GLuint computeProgram = glCreateProgram();
    glAttachShader(computeProgram, computeShader);
    glLinkProgram(computeProgram);

    return computeProgram;
}

//this load multi-filed shader program
//actually it is in fact single filed shader
//that is just simply joined from several files
static const std::string ParseShaderProject(std::vector<std::string> filepaths)
{
    //std::string program;
    std::stringstream program;
    for (int i = 0; i < filepaths.size(); ++i)
    {
        //special overload for inputing custom fractals
        //it comes before main and shapesManager to be able to use other dependencies
        if (i == filepaths.size() - 3)
        {
            //carefully place function for custom shape so it does not breaks the program
            std::ifstream file(filepaths[i]);
            std::string line;
            while (std::getline(file, line))
            {
                program << line << '\n';
            }
        }
        else
        {
            //join each file
            std::ifstream file(filepaths[i]);
            std::string line;
            while (std::getline(file, line))
            {
                program << line << '\n';
            }
        }

    }

    return program.str();
}

//taking input
//UNUSED
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods)
{
    //moving camera:
    if (action == GLFW_REPEAT)
    {
        if (key == 87) //w
        {

        }
        if (key == 83) //s
        {

        }
    }
    if (action == GLFW_REPEAT)
    {
        std::cout << key << std::endl;
    }

}

//UNUSED
void mouse_callback(GLFWwindow* window, int button, int action, int mods)
{
    std::cout << button << std::endl;
    if (action == GLFW_REPEAT)
    {
        std::cout << button << std::endl;
    }
}

void mouse_pos_callback(GLFWwindow* window, double xpos, double ypos)
{

}

int main(int argc, char* argv[])
{
    const unsigned int sizeX = 1280;
    const unsigned int sizeY = 720;
    GLFWwindow* window;

    if (!glfwInit())
    {
        return -1;
    }

    window = glfwCreateWindow(sizeX, sizeY, "Ray Marching", NULL, NULL);
    if (!window)
    {
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    glfwSetKeyCallback(window, key_callback);
    glfwSetMouseButtonCallback(window, mouse_callback);
    glfwSetCursorPosCallback(window, mouse_pos_callback);

    //this has to be after cretaing context
    glewInit();
    if (glewInit() != GLEW_OK)
    {
        std::cout << "glew error!" << std::endl;
    }

    //what the hell is that and why is it needed
    GLuint VAO, VBO, EBO;
    glCreateVertexArrays(1, &VAO);
    glCreateBuffers(1, &VBO);
    glCreateBuffers(1, &EBO);

    glNamedBufferData(VBO, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glNamedBufferData(EBO, sizeof(indices), indices, GL_STATIC_DRAW);

    glEnableVertexArrayAttrib(VAO, 0);
    glVertexArrayAttribBinding(VAO, 0, 0);
    glVertexArrayAttribFormat(VAO, 0, 3, GL_FLOAT, GL_FALSE, 0);

    glEnableVertexArrayAttrib(VAO, 1);
    glVertexArrayAttribBinding(VAO, 1, 0);
    glVertexArrayAttribFormat(VAO, 1, 2, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat));

    glVertexArrayVertexBuffer(VAO, 0, VBO, 0, 5 * sizeof(GLfloat));
    glVertexArrayElementBuffer(VAO, EBO);

    //texture setup to actually "see" whatever the program outputs
    GLuint screenTex;
    glCreateTextures(GL_TEXTURE_2D, 1, &screenTex);
    glTextureParameteri(screenTex, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTextureParameteri(screenTex, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTextureParameteri(screenTex, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTextureParameteri(screenTex, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTextureStorage2D(screenTex, 1, GL_RGBA32F, sizeX, sizeY);
    glBindImageTexture(0, screenTex, 0, GL_FALSE, 0, GL_WRITE_ONLY, GL_RGBA32F);

    //vertex and fragment shaders to show compute shader
    int screenProgram = CreateClassicShader(screenVertexShaderSource, screenFragmentShaderSource);

    //scene initialization
    List<MarchingObject<GLfloat>> mainScene;

    //loading shader from file:
    //"shaders/customShape.glsl",
    std::vector<std::string> projectFiles = {
        "shaders/uniforms.glsl",
        "shaders/calculations.glsl",
        "shaders/shapes.glsl",
        "shaders/connections.glsl",
        "shaders/repeatings.glsl",
        "shaders/textures.glsl",
        "shaders/customShape.glsl",
        "shaders/shapesManager.glsl",
        "shaders/main.glsl"
    };
    if (argc > 1)
    {
        projectFiles[projectFiles.size() - 3] = argv[1];
    }

    std::string shaderSource = ParseShaderProject(projectFiles);
    GLuint mainProgram = CreateComputeShader(shaderSource.c_str());

    //here setup for objects in scene

    //custom object
    if (argc > 1)
    {
        //here goes fractal
        mainScene.push_back(MarchingObject<GLfloat>(vect3<GLfloat>(0, 0, -0.5), vect3<GLfloat>(0, 0, 0), vect4<GLfloat>(1.0, 1.0, 1.0, 0.0), 7, 0, 0.5, 0, vect4<GLfloat>(1.0, 1.0, 1.0, 0.0), vect4<GLfloat>(0.2, 0.2, 0.2, 1.0)));
        //mainScene.push_back(MarchingObject<GLfloat>(vect3<GLfloat>(1, 0, -5), vect3<GLfloat>(0, 67, 0), vect4<GLfloat>(2.0, 2.0, 2.0, 0.0), 2, 0, 0.5, 5, vect4<GLfloat>(1.0, 0.3, 0.2, 0.0), vect4<GLfloat>(0.3, 0.3, 0.3, 3.0)));
        //mainScene.push_back(MarchingObject<GLfloat>(vect3<GLfloat>(0, 0, -5), vect3<GLfloat>(0, 0, 0), vect4<GLfloat>(2.0, 2.0, 2.0, 0.0), 1, 1, 0.5, 5, vect4<GLfloat>(1.0, 0.3, 0.2, 0.0), vect4<GLfloat>(0.3, 0.3, 0.3, 3.0)));
    }
    else //sample scene
    {
        mainScene.push_back(MarchingObject<GLfloat>(vect3<GLfloat>(0.5, -3, -5), vect3<GLfloat>(45, 45, 0), vect4<GLfloat>(8, 0.5, 8, 0.0), 2, 4, 0.4, 4, vect4<GLfloat>(0.7, 1.0, 0.9, 0.0), vect4<GLfloat>(0.2, 0.2, 0.2, 1.0)));
        mainScene.push_back(MarchingObject<GLfloat>(vect3<GLfloat>(1, 0, -5), vect3<GLfloat>(0, 0, 0), vect4<GLfloat>(1.0, 1.0, 1.0, 0.0), 1, 0, 0.5, 3, vect4<GLfloat>(1.0, 1.0, 1.0, 0.0), vect4<GLfloat>(1.0, 1.0, 1.0, 1.0)));
    }


    //main program loop section
    while (!glfwWindowShouldClose(window))
    {
        glUseProgram(mainProgram);
        glDispatchCompute(std::ceil(sizeX / 8), std::ceil(sizeY / 4), 1);
        glMemoryBarrier(GL_ALL_BARRIER_BITS);

        //here setting data within our shader

        //here global serialization
        oneoffSerialize(mainProgram);
        globalSerialize(mainProgram, mainScene);

        glUseProgram(screenProgram);
        glBindTextureUnit(0, screenTex);
        glUniform1i(glGetUniformLocation(screenProgram, "screen"), 0);
        glBindVertexArray(VAO);
        glDrawElements(GL_TRIANGLES, sizeof(indices) / sizeof(indices[0]), GL_UNSIGNED_INT, 0);

        glfwSwapBuffers(window);
        glfwPollEvents();

        //std::cout << "time check" << std::endl;

        //general update
        for (auto& i : mainScene)
        {
            i.data.rot.y += 1;
            //i.data.rot.z += 1;
            //i.data.pos.z += 0.025;
        }
    }

    glfwDestroyWindow(window);
    glfwTerminate();
}