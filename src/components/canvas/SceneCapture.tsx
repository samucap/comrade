import { useEffect } from 'react';
import { useThree } from '@react-three/fiber';
import useStore from '../../store/useStore';

export function SceneCapture() {
    const { gl, scene, camera } = useThree();
    const capturePending = useStore((state) => state.capturePending);
    const setCapturePending = useStore((state) => state.setCapturePending);
    const selectedId = useStore((state) => state.selectedId);
    const sceneObjects = useStore((state) => state.sceneObjects);
    const updateAssetThumbnail = useStore((state) => state.updateAssetThumbnail);

    useEffect(() => {
        if (capturePending) {
            // Render the scene to ensure it's up to date
            gl.render(scene, camera);

            // Capture the canvas as a data URL
            const dataUrl = gl.domElement.toDataURL('image/png');

            // Find the asset ID associated with the selected object
            // If no object is selected, we might want to just save it to a "Scene Snapshot" or similar, 
            // but for now let's target the selected object's asset if possible.

            if (selectedId) {
                const selectedObject = sceneObjects.find(obj => obj.id === selectedId);
                if (selectedObject && selectedObject.assetId) {
                    updateAssetThumbnail(selectedObject.assetId, dataUrl);
                    console.log('Thumbnail updated for asset:', selectedObject.assetId);
                } else {
                    console.warn('Selected object has no associated asset ID');
                }
            } else {
                console.warn('No object selected for thumbnail update');
            }

            // Reset pending state
            setCapturePending(false);
        }
    }, [capturePending, gl, scene, camera, selectedId, sceneObjects, updateAssetThumbnail, setCapturePending]);

    return null;
}
