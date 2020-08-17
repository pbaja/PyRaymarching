import time, os
import moderngl_window as mglw
import numpy as np
from moderngl_window.resources import programs 
from moderngl_window.meta import ProgramDescription 
from moderngl_window.conf import settings


class Window:

    def __init__(self, config):
        # Create window
        settings = {
            'class': 'moderngl_window.context.glfw.Window',
            'gl_version': (4, 3),
            'size': (640, 480),
            'aspect_ratio': 1.33333,
            'vsync': False
        }
        mglw.settings.WINDOW.update(settings)
        self.window = mglw.create_window_from_settings()
        self.window.position = (0,0)

        # Setup directories
        shaders_path = os.path.abspath("app/shaders")
        mglw.resources.register_program_dir(shaders_path)

        # Load program
        prog_desc = ProgramDescription(vertex_shader='vert.glsl', fragment_shader='frag.glsl')
        self.prog = programs.load(prog_desc)

        # Vertices
        vertices = np.array([
            # x     y     u     v
            -1.0, -1.0, 0.0, 0.0,
             1.0, -1.0, 1.0, 0.0,
            -1.0,  1.0, 0.0, 1.0,
             1.0,  1.0, 1.0, 1.0
        ]).astype(np.float32)
        vertices_buffer = self.window.ctx.buffer(vertices)
        content = [(vertices_buffer, '2f 2f', 'in_vert', 'in_uv')]

        # Triangles
        triangles = np.array([
            0, 1, 2,
            1, 2, 3
        ]).astype(np.int32)
        triangles_buffer = self.window.ctx.buffer(triangles)

        # Create vertex array
        self.vao = self.window.ctx.vertex_array(self.prog, content, triangles_buffer)

        # Parameters
        self.params = {}
        self.params["Time"] = self.prog.get("Time", None)
        
    def render(self, delta, time):
        if self.params["Time"] is not None: self.params["Time"].value = time
        self.vao.render()

    def loop(self):
        fps_timer = 0.0
        fps_counter = 0
        last_frame = 0.0
        start_frame = time.time()
        while not self.window.is_closing:
            # Delta
            delta = time.time()-last_frame
            last_frame = time.time()

            # FPS Counter
            fps_timer += delta
            fps_counter += 1
            if fps_timer >= 1.0:
                print(f"FPS: {fps_counter/fps_timer}")
                fps_timer = 0.0
                fps_counter = 0

            # Render
            self.window.clear()
            self.render(delta, time.time()-start_frame)
            self.window.swap_buffers()

    def close(self):
        self.window.close()