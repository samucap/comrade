import { useMemo } from 'react';
import * as THREE from 'three';
import useStore from '../../store/useStore';

export function Scenery() {
    const scenery = useStore((state) => state.environment.scenery);

    if (scenery === 'none') return null;

    return (
        <group>
            {scenery === 'city' && <CityScenery />}
            {scenery === 'nature' && <NatureScenery />}
            {scenery === 'studio' && <StudioScenery />}
        </group>
    );
}

function CityScenery() {
    // Simple placeholder for a city: a ground plane and some random boxes as buildings
    const buildings = useMemo(() => {
        const items = [];
        for (let i = 0; i < 20; i++) {
            const height = Math.random() * 10 + 5;
            const width = Math.random() * 4 + 2;
            const depth = Math.random() * 4 + 2;
            const x = (Math.random() - 0.5) * 100;
            const z = (Math.random() - 0.5) * 100;
            // Avoid center
            if (Math.abs(x) < 10 && Math.abs(z) < 10) continue;
            items.push({ position: [x, height / 2, z], args: [width, height, depth] });
        }
        return items;
    }, []);

    return (
        <group>
            <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, -0.1, 0]} receiveShadow>
                <planeGeometry args={[200, 200]} />
                <meshStandardMaterial color="#333333" />
            </mesh>
            {buildings.map((b, i) => (
                <mesh key={i} position={b.position as any} castShadow receiveShadow>
                    <boxGeometry args={b.args as any} />
                    <meshStandardMaterial color="#555555" />
                </mesh>
            ))}
        </group>
    );
}

function NatureScenery() {
    // Simple placeholder for nature: green ground and some "trees" (cylinders + cones)
    const trees = useMemo(() => {
        const items = [];
        for (let i = 0; i < 30; i++) {
            const x = (Math.random() - 0.5) * 80;
            const z = (Math.random() - 0.5) * 80;
            if (Math.abs(x) < 5 && Math.abs(z) < 5) continue;
            items.push({ position: [x, 0, z], scale: Math.random() * 0.5 + 0.5 });
        }
        return items;
    }, []);

    return (
        <group>
            <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, -0.1, 0]} receiveShadow>
                <planeGeometry args={[200, 200]} />
                <meshStandardMaterial color="#2d4c1e" />
            </mesh>
            {trees.map((t, i) => (
                <group key={i} position={t.position as any} scale={t.scale}>
                    {/* Trunk */}
                    <mesh position={[0, 1, 0]} castShadow>
                        <cylinderGeometry args={[0.2, 0.4, 2]} />
                        <meshStandardMaterial color="#4a3c31" />
                    </mesh>
                    {/* Leaves */}
                    <mesh position={[0, 3, 0]} castShadow>
                        <coneGeometry args={[1.5, 3, 8]} />
                        <meshStandardMaterial color="#1e5922" />
                    </mesh>
                </group>
            ))}
        </group>
    );
}

function StudioScenery() {
    // Simple studio backdrop
    return (
        <group>
            <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, -0.1, 0]} receiveShadow>
                <planeGeometry args={[100, 100]} />
                <meshStandardMaterial color="#222222" roughness={0.8} />
            </mesh>
            <mesh position={[0, 10, -20]} receiveShadow>
                <planeGeometry args={[100, 40]} />
                <meshStandardMaterial color="#222222" roughness={0.8} />
            </mesh>
        </group>
    );
}
