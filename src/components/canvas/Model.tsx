import { useGLTF, TransformControls } from '@react-three/drei';
import { useMemo } from 'react';
import type { ThreeEvent } from '@react-three/fiber';
import type { SceneObject } from '../../types/store';
import useStore from '../../store/useStore';
import * as THREE from 'three';

interface ModelProps {
    object: SceneObject;
}

export function Model({ object }: ModelProps) {
    const { scene } = useGLTF(object.src);
    const selectObject = useStore((state) => state.selectObject);
    const updateObjectTransform = useStore((state) => state.updateObjectTransform);
    const selectedId = useStore((state) => state.selectedId);
    const transformMode = useStore((state) => state.transformMode);
    const renderMode = useStore((state) => state.renderMode);
    const isSelected = selectedId === object.id;

    // Clone scene to avoid sharing state between instances of same model
    const sceneClone = useMemo(() => scene.clone(), [scene]);

    // Apply render mode
    useMemo(() => {
        sceneClone.traverse((child) => {
            if (child instanceof THREE.Mesh) {
                if (!child.userData.originalMaterial) {
                    child.userData.originalMaterial = child.material;
                }

                if (renderMode === 'wireframe') {
                    child.material = new THREE.MeshBasicMaterial({
                        color: 0x00ff00,
                        wireframe: true,
                    });
                } else if (renderMode === 'matcap') {
                    child.material = new THREE.MeshNormalMaterial();
                } else {
                    child.material = child.userData.originalMaterial;
                }
            }
        });
    }, [sceneClone, renderMode]);

    const handleClick = (e: ThreeEvent<MouseEvent>) => {
        e.stopPropagation();
        selectObject(object.id);
    };

    return (
        <>
            <primitive
                object={sceneClone}
                position={[object.position.x, object.position.y, object.position.z]}
                rotation={[object.rotation.x, object.rotation.y, object.rotation.z]}
                scale={[object.scale.x, object.scale.y, object.scale.z]}
                onClick={handleClick}
            />
            {isSelected && (
                <TransformControls
                    object={sceneClone}
                    mode={transformMode}
                    onObjectChange={(e) => {
                        const target = e?.target as any;
                        if (!target?.object) return;
                        const obj = target.object as THREE.Object3D;
                        updateObjectTransform(object.id, 'position', { x: obj.position.x, y: obj.position.y, z: obj.position.z });
                        updateObjectTransform(object.id, 'rotation', { x: obj.rotation.x, y: obj.rotation.y, z: obj.rotation.z });
                        updateObjectTransform(object.id, 'scale', { x: obj.scale.x, y: obj.scale.y, z: obj.scale.z });
                    }}
                />
            )}
        </>
    );
}
