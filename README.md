# Prompt Weaver - 3D Asset Generation & Animation Platform

Prompt Weaver is a next-generation web-based 3D editor and asset generation platform. Built with React, Three.js, and Tailwind CSS, it combines powerful 3D manipulation tools with AI-driven workflows to streamline the creation of immersive content.

## Features

### 🛠️ Professional 3D Modeling & Editing
- **Precision Transformation**:
  - **Gizmo Manipulation**: Intuitive on-screen handles for Translation, Rotation, and Scaling in local and world space.
  - **Numeric Input**: Fine-tune object properties via the Inspector panel for pixel-perfect placement.
- **Scene Composition**:
  - **Multi-Object Management**: Import and arrange multiple 3D assets to compose complex scenes.
  - **Scene Outliner**: Hierarchical view of all objects for easy selection and organization.
- **Visual Inspection**:
  - **Multi-Mode Rendering**: Analyze topology with Wireframe mode, check surface details with Matcap, or view final quality with PBR.
  - **Lighting & Environment**: Adjustable studio lighting and infinite grid systems to visualize assets in different contexts.
- **Workflow Efficiency**:
  - **History Management**: Comprehensive Undo/Redo stack supporting all transform operations.
  - **Keyboard Shortcuts**: Industry-standard hotkeys for rapid workflow.

### 🎨 Workspace & Asset Management
- **Asset Library**: Centralized grid view to organize and preview your generated 3D models.
- **Unified Workflow**: Seamless switching between the Workspace (Library), Editor (3D View), and Generation tools via a collapsible sidebar.
- **Smart Management**: Track asset status, types, and creation dates.

### ✨ AI Generation Interfaces (Simulated)
- **Text to 3D**: Create 3D models from natural language descriptions. Supports multiple art styles including Realistic, Cartoon, Low Poly, and Voxel.
- **Image to 3D**: Transform 2D reference images into 3D geometry.

### 🦴 Rigging & Animation
- **Auto-Rigging**: Automated workflow to detect joints and skin weights, preparing static models for animation.
- **Animation Library**: Extensive collection of preset motions (Idle, Walk, Run, Dance, Emotes).
- **Timeline Control**: Full playback control with scrubbing, looping, and variable playback speeds.

## Tech Stack

- **Frontend**: React, TypeScript, Vite
- **3D Engine**: Three.js, @react-three/fiber, @react-three/drei
- **Styling**: Tailwind CSS (v3)
- **State Management**: Zustand + Zundo (Temporal/Undo)
- **Icons**: Lucide React

## Getting Started

1. **Install Dependencies**
   ```bash
   npm install
   ```

2. **Run Development Server**
   ```bash
   npm run dev
   ```

3. **Open in Browser**
   Navigate to `http://localhost:5173` to explore the application.

## Controls

- **Orbit**: Left Click + Drag
- **Pan**: Right Click + Drag
- **Zoom**: Scroll Wheel
- **Select**: Click on an object
- **Transform**: Use the Gizmo or Inspector panel
- **Undo/Redo**: `CMD+Z` / `CMD+SHIFT+Z`


### TODO
- include download options or converting to different 3d formats glb, fbx or whatever else
- when 3d model's been loaded or generated, it doesn't show up in the library, prolly cuz it's not in the store?
- a lot of the more specialized functionalities are not there, need to map out the full feature set
- need to decide on which models to use to generate image from text, from image, animation (rigging)
- is there any way to maintain state between going in and out of editor? Should there be a smaller like mini-map top-down orthographic view of the scene?
- are auto-rigging and library the same?
- The sidebar buttons should be:
  - Image: for image generation via text, ability to choose model, with/without image for reference
    - generate-multi-view
    - a/t pose
    - image strength
    - aspect ratio
    - generate button
  
  - 3D Model: for 3D model generation via text, ability to choose model, with/without image for reference, batching images for cheaper generation
    - generate-multi-view
    - select ai model
    - a/t pose
    - symmetry?
    - aspect ratio
    - generate button

  - Editor: for editing 3D models. maintain the viewport, while adding to sidebars
    - auto-rigging
    - animation library
    - timeline control
    - ability to remesh and retexturize?????
  
  - Library: for managing assets: images, 3d models, animations, textured models