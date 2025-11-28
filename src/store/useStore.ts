import { create } from 'zustand';
import { temporal } from 'zundo';
import type { EditorState, SceneObject, Vector3Data, AnimationState } from '../types/store';

const useStore = create<EditorState>()(
    temporal(
        (set) => ({
            // Workspace State
            currentView: 'workspace',
            assets: [],

            // Viewer State
            renderMode: 'pbr',
            environment: {
                gridVisible: true,
                background: '#050505',
                lightIntensity: 1,
            },
            animation: {
                currentAnimation: null,
                isPlaying: false,
                playbackSpeed: 1,
                loop: true,
            },

            // Editor State
            sceneObjects: [],
            selectedId: null,
            transformMode: 'translate',

            // Actions
            setView: (view) => set({ currentView: view }),

            addAsset: (asset) => set((state) => ({ assets: [asset, ...state.assets] })),

            removeAsset: (id) => set((state) => ({ assets: state.assets.filter((a) => a.id !== id) })),

            setRenderMode: (mode) => set({ renderMode: mode }),

            updateEnvironment: (settings) => set((state) => ({ environment: { ...state.environment, ...settings } })),

            updateAnimation: (settings) => set((state) => ({ animation: { ...state.animation, ...settings } })),

            addObject: (url: string, name: string) => {
                const newObject: SceneObject = {
                    id: crypto.randomUUID(),
                    name,
                    src: url,
                    position: { x: 0, y: 0, z: 0 },
                    rotation: { x: 0, y: 0, z: 0 },
                    scale: { x: 1, y: 1, z: 1 },
                    visible: true,
                    locked: false,
                };
                set((state) => ({
                    sceneObjects: [...state.sceneObjects, newObject],
                    currentView: 'editor' // Auto-switch to editor when adding object
                }));
            },

            removeObject: (id: string) => {
                set((state) => ({
                    sceneObjects: state.sceneObjects.filter((obj) => obj.id !== id),
                    selectedId: state.selectedId === id ? null : state.selectedId,
                }));
            },

            selectObject: (id: string | null) => {
                set({ selectedId: id });
            },

            updateObjectTransform: (id: string, prop: 'position' | 'rotation' | 'scale', val: Vector3Data) => {
                set((state) => ({
                    sceneObjects: state.sceneObjects.map((obj) =>
                        obj.id === id ? { ...obj, [prop]: val } : obj
                    ),
                }));
            },

            setTransformMode: (mode) => {
                set({ transformMode: mode });
            },
        })
    )
);

export default useStore;
