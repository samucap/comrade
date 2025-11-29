import { create } from 'zustand';
import { temporal } from 'zundo';
import { persist, createJSONStorage } from 'zustand/middleware';
import type { EditorState, SceneObject, Vector3Data } from '../types/store';
import { idbStorage } from './storage';

const useStore = create<EditorState>()(
    temporal(
        persist(
            (set) => ({
                // Workspace State
                currentView: 'library',
                assets: [],

                // Viewer State
                renderMode: 'pbr',
                environment: {
                    gridVisible: true,
                    background: '#050505',
                    lightIntensity: 1,
                    scenery: 'none',
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
                capturePending: false,

                // Actions
                setView: (view) => set({ currentView: view }),

                addAsset: (asset) => set((state) => ({ assets: [asset, ...state.assets] })),

                removeAsset: (id) => set((state) => ({ assets: state.assets.filter((a) => a.id !== id) })),

                updateAssetThumbnail: (id, thumbnail) => set((state) => ({
                    assets: state.assets.map((a) => a.id === id ? { ...a, thumbnail } : a)
                })),

                setRenderMode: (mode) => set({ renderMode: mode }),

                updateEnvironment: (settings) => set((state) => ({ environment: { ...state.environment, ...settings } })),

                updateAnimation: (settings) => set((state) => ({ animation: { ...state.animation, ...settings } })),

                addObject: (url: string, name: string, assetId?: string) => {
                    const newObject: SceneObject = {
                        id: crypto.randomUUID(),
                        assetId,
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
                        currentView: 'editor'
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

                setCapturePending: (pending) => {
                    set({ capturePending: pending });
                },
            }),
            {
                name: 'prompt-weaver-storage',
                storage: createJSONStorage(() => idbStorage),
                partialize: (state) => ({
                    assets: state.assets,
                    sceneObjects: state.sceneObjects,
                    environment: state.environment
                }),
            }
        )
    )
);

export default useStore;
