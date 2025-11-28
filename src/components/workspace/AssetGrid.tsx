import type { Asset } from '../../types/store';
import useStore from '../../store/useStore';
import { Button } from '../ui/Button';
import { Box, Clock, Play, Trash2 } from 'lucide-react';

export function AssetGrid() {
    const assets = useStore((state) => state.assets);
    const addAsset = useStore((state) => state.addAsset);

    // Mock function to add a dummy asset for testing
    const handleMockGenerate = () => {
        addAsset({
            id: crypto.randomUUID(),
            name: `Generation #${Math.floor(Math.random() * 1000)}`,
            type: 'text-to-3d',
            status: 'ready',
            thumbnail: 'https://placehold.co/400x400/18181b/ffffff?text=3D',
            url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Binary/Duck.glb',
            createdAt: Date.now(),
        });
    };

    return (
        <div className="flex-1 h-full bg-black p-8 overflow-y-auto">
            <div className="max-w-7xl mx-auto flex flex-col gap-8">

                {/* Header */}
                <div className="flex justify-between items-end">
                    <div className="flex flex-col gap-2">
                        <h1 className="text-3xl font-bold text-white tracking-tight">Library</h1>
                        <p className="text-zinc-500">Manage your generated 3D assets.</p>
                    </div>
                    <Button onClick={handleMockGenerate} className="bg-white text-black hover:bg-zinc-200 px-4 py-2">
                        Mock Generate
                    </Button>
                </div>

                {/* Grid */}
                {assets.length === 0 ? (
                    <div className="w-full h-64 border border-dashed border-zinc-800 rounded-lg flex flex-col items-center justify-center gap-4 text-zinc-500">
                        <Box className="w-8 h-8 opacity-50" />
                        <p>No assets found. Start generating!</p>
                    </div>
                ) : (
                    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                        {assets.map((asset) => (
                            <AssetCard key={asset.id} asset={asset} />
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
}

function AssetCard({ asset }: { asset: Asset }) {
    const addObject = useStore((state) => state.addObject);
    const removeAsset = useStore((state) => state.removeAsset);

    const handleLoad = () => {
        if (asset.url) {
            addObject(asset.url, asset.name);
        }
    };

    return (
        <div className="group relative aspect-square bg-zinc-900 rounded-lg overflow-hidden border border-zinc-800 hover:border-zinc-600 transition-colors">
            {/* Thumbnail */}
            <div className="absolute inset-0 bg-zinc-800">
                {asset.thumbnail && (
                    <img src={asset.thumbnail} alt={asset.name} className="w-full h-full object-cover opacity-80 group-hover:opacity-100 transition-opacity" />
                )}
            </div>

            {/* Overlay Actions */}
            <div className="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-2">
                <Button onClick={handleLoad} className="bg-white text-black hover:bg-zinc-200 rounded-full p-3">
                    <Play className="w-5 h-5 fill-current" />
                </Button>
            </div>

            {/* Info Bar */}
            <div className="absolute bottom-0 left-0 w-full p-3 bg-gradient-to-t from-black/90 to-transparent flex justify-between items-end">
                <div className="flex flex-col gap-0.5 overflow-hidden">
                    <span className="text-sm font-medium text-white truncate">{asset.name}</span>
                    <span className="text-[10px] text-zinc-400 uppercase flex items-center gap-1">
                        {asset.type} • <Clock className="w-3 h-3" /> {new Date(asset.createdAt).toLocaleDateString()}
                    </span>
                </div>

                <div className="flex gap-1">
                    <Button onClick={() => removeAsset(asset.id)} className="text-zinc-400 hover:text-red-500 p-1">
                        <Trash2 className="w-4 h-4" />
                    </Button>
                </div>
            </div>
        </div>
    );
}
