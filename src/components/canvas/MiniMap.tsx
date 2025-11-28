import useStore from '../../store/useStore';

export function MiniMap() {
    const sceneObjects = useStore((state) => state.sceneObjects);

    return (
        <div className="absolute bottom-4 left-4 w-48 h-48 border-2 border-zinc-800 bg-black rounded-lg overflow-hidden shadow-lg z-50">
            <div className="w-full h-full relative bg-zinc-900 grid place-items-center">
                <div className="absolute inset-0 opacity-20"
                    style={{ backgroundImage: 'radial-gradient(circle, #333 1px, transparent 1px)', backgroundSize: '10px 10px' }}>
                </div>

                {/* Represent objects as dots */}
                {sceneObjects.map(obj => (
                    <div
                        key={obj.id}
                        className="absolute w-3 h-3 bg-blue-500 rounded-full transform -translate-x-1/2 -translate-y-1/2 border border-white shadow-sm"
                        style={{
                            left: `${50 + obj.position.x * 5}%`,
                            top: `${50 + obj.position.z * 5}%`
                        }}
                    />
                ))}

                {/* Center Marker */}
                <div className="absolute top-1/2 left-1/2 w-2 h-2 bg-white rounded-full transform -translate-x-1/2 -translate-y-1/2" />

                <span className="absolute bottom-1 right-2 text-[10px] text-zinc-500 font-mono">TOP VIEW</span>
            </div>
        </div>
    );
}
