import { Canvas } from '@react-three/fiber';
import { Grid, OrbitControls } from '@react-three/drei';
import * as THREE from 'three';
import useStore from '../../store/useStore';
import { Model } from './Model';

export function Viewport() {
    const sceneObjects = useStore((state) => state.sceneObjects);
    const environment = useStore((state) => state.environment);

    return (
        <div className="w-full h-full bg-[#050505]">
            <Canvas
                camera={{ position: [10, 10, 10], fov: 50 }}
                onCreated={({ scene }) => {
                    scene.fog = new THREE.FogExp2('#050505', 0.02);
                }}
            >
                <ambientLight intensity={0.3 * environment.lightIntensity} />
                <directionalLight position={[10, 10, 5]} intensity={2 * environment.lightIntensity} castShadow />

                {environment.gridVisible && (
                    <Grid
                        args={[100, 100]}
                        cellColor="#2a2a2a"
                        sectionColor="rgba(255, 255, 255, 0.1)"
                        infiniteGrid
                        fadeDistance={50}
                        fadeStrength={1.5}
                    />
                )}

                {sceneObjects.map((obj) => (
                    <Model key={obj.id} object={obj} />
                ))}

                <OrbitControls makeDefault />
            </Canvas>
        </div>
    );
}
