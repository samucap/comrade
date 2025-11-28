export type TransformMode = 'translate' | 'rotate' | 'scale';
export type ViewMode = 'image-gen' | 'model-gen' | 'editor' | 'library';
export type AssetType = 'text-to-3d' | 'image-to-3d' | 'upload';
export type AssetStatus = 'generating' | 'ready' | 'failed';

export interface Vector3Data {
    x: number;
    y: number;
    z: number;
}

export interface Asset {
    id: string;
    name: string;
    type: AssetType;
    status: AssetStatus;
    thumbnail?: string;
    url?: string;
    createdAt: number;
}

export interface SceneObject {
    id: string;              // UUID v4
    name: string;            // e.g., "MODULE_01"
    src: string;             // URL to .glb asset
    position: Vector3Data;
    rotation: Vector3Data;
    scale: Vector3Data;
    visible: boolean;
    locked: boolean;
}

export type RenderMode = 'pbr' | 'wireframe' | 'matcap';

export interface EnvironmentSettings {
    gridVisible: boolean;
    background: string;
    lightIntensity: number;
}

export interface AnimationState {
    currentAnimation: string | null;
    isPlaying: boolean;
    playbackSpeed: number;
    loop: boolean;
}

export interface EditorState {
    // Workspace State
    currentView: ViewMode;
    assets: Asset[];

    // Viewer State
    renderMode: RenderMode;
    environment: EnvironmentSettings;
    animation: AnimationState;

    // Editor State
    sceneObjects: SceneObject[];
    selectedId: string | null;
    transformMode: TransformMode;

    // Actions
    setView: (view: ViewMode) => void;
    addAsset: (asset: Asset) => void;
    removeAsset: (id: string) => void;

    setRenderMode: (mode: RenderMode) => void;
    updateEnvironment: (settings: Partial<EnvironmentSettings>) => void;
    updateAnimation: (settings: Partial<AnimationState>) => void;

    addObject: (url: string, name: string) => void;
    removeObject: (id: string) => void;
    selectObject: (id: string | null) => void;
    updateObjectTransform: (id: string, prop: 'position' | 'rotation' | 'scale', val: Vector3Data) => void;
    setTransformMode: (mode: TransformMode) => void;
}
