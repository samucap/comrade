import { useState } from 'react';
import { Search, Filter, Trash2, ExternalLink, Box, Image as ImageIcon, Clapperboard, Upload } from 'lucide-react';
import useStore from '../../store/useStore';
import { cn } from '../../lib/utils';
import type { Asset } from '../../types/store';

export function AssetGrid() {
    const { assets, removeAsset, addObject, addAsset } = useStore();
    const [filter, setFilter] = useState<'all' | 'model' | 'image' | 'animation'>('all');
    const [search, setSearch] = useState('');

    const filteredAssets = assets.filter(asset => {
        const matchesSearch = asset.name.toLowerCase().includes(search.toLowerCase());
        const matchesFilter = filter === 'all'
            ? true
            : filter === 'model'
                ? asset.type === 'text-to-3d'
                : filter === 'image'
                    ? asset.type === 'image-to-3d'
                    : false; // TODO: Add animation type support
        return matchesSearch && matchesFilter;
    });

    return (
        <div className="flex-1 h-full bg-black flex flex-col">
            {/* Header */}
            <div className="h-16 border-b border-zinc-800 flex items-center justify-between px-6 bg-zinc-900/50 backdrop-blur-sm">
                <h1 className="text-xl font-bold text-white tracking-tight">Library</h1>

                <div className="flex items-center gap-4">
                    <div className="relative">
                        <Search className="w-4 h-4 absolute left-3 top-1/2 transform -translate-y-1/2 text-zinc-500" />
                        <input
                            type="text"
                            placeholder="Search assets..."
                            value={search}
                            onChange={(e) => setSearch(e.target.value)}
                            className="w-64 bg-zinc-900 border border-zinc-800 rounded-full py-1.5 pl-9 pr-4 text-sm text-white focus:outline-none focus:border-zinc-700 transition-colors"
                        />
                    </div>

                    <div className="h-6 w-px bg-zinc-800" />

                    <input
                        type="file"
                        id="asset-upload"
                        className="hidden"
                        accept=".glb,.gltf"
                        onChange={(e) => {
                            const file = e.target.files?.[0];
                            if (!file) return;

                            const name = file.name.split('.')[0];
                            const reader = new FileReader();
                            reader.onload = (e) => {
                                const result = e.target?.result as string;
                                if (!result) return;

                                addObject(result, name);
                                addAsset({
                                    id: crypto.randomUUID(),
                                    name,
                                    type: 'upload', // Or 'model'
                                    status: 'ready',
                                    url: result,
                                    thumbnail: 'https://images.unsplash.com/photo-1614730341194-75c6074065db?q=80&w=2074&auto=format&fit=crop',
                                    createdAt: Date.now(),
                                });
                            };
                            reader.readAsDataURL(file);
                            e.target.value = ''; // Reset
                        }}
                    />
                    <label
                        htmlFor="asset-upload"
                        className="flex items-center gap-2 px-4 py-1.5 bg-blue-600 hover:bg-blue-500 text-white text-sm font-medium rounded-full cursor-pointer transition-colors shadow-lg shadow-blue-900/20"
                    >
                        <Upload className="w-4 h-4" />
                        Import
                    </label>
                </div>
            </div>

            {/* Filter Tabs */}
            <div className="px-6 py-4 flex gap-2 border-b border-zinc-800/50">
                {[
                    { id: 'all', label: 'All Assets', icon: null },
                    { id: 'model', label: '3D Models', icon: Box },
                    { id: 'image', label: 'Images', icon: ImageIcon },
                    { id: 'animation', label: 'Animations', icon: Clapperboard },
                ].map((tab) => (
                    <button
                        key={tab.id}
                        onClick={() => setFilter(tab.id as any)}
                        className={cn(
                            "px-4 py-2 rounded-full text-sm font-medium transition-all flex items-center gap-2",
                            filter === tab.id
                                ? "bg-white text-black"
                                : "bg-zinc-900 text-zinc-400 hover:bg-zinc-800 hover:text-white"
                        )}
                    >
                        {tab.icon && <tab.icon className="w-4 h-4" />}
                        {tab.label}
                    </button>
                ))}
            </div>

            {/* Grid */}
            <div className="flex-1 overflow-y-auto p-6">
                {filteredAssets.length === 0 ? (
                    <div className="h-full flex flex-col items-center justify-center text-zinc-500 gap-4">
                        <Box className="w-12 h-12 opacity-20" />
                        <p>No assets found</p>
                    </div>
                ) : (
                    <div className="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                        {filteredAssets.map((asset) => (
                            <AssetCard
                                key={asset.id}
                                asset={asset}
                                onRemove={() => removeAsset(asset.id)}
                                onLoad={() => {
                                    if (asset.url) {
                                        addObject(asset.url, asset.name, asset.id);
                                    }
                                }}
                            />
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
}

function AssetCard({ asset, onRemove, onLoad }: { asset: Asset; onRemove: () => void; onLoad: () => void }) {
    return (
        <div className="group relative bg-zinc-900 rounded-xl overflow-hidden border border-zinc-800 hover:border-zinc-600 transition-all hover:shadow-xl hover:shadow-black/50">
            {/* Thumbnail */}
            <div className="aspect-square relative overflow-hidden bg-zinc-950">
                {asset.thumbnail ? (
                    <img
                        src={asset.thumbnail}
                        alt={asset.name}
                        className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                    />
                ) : (
                    <div className="w-full h-full bg-zinc-900 flex items-center justify-center group-hover:scale-110 transition-transform duration-500">
                        <Box className="w-12 h-12 text-zinc-700" />
                    </div>
                )}
                <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />

                {/* Actions Overlay */}
                <div className="absolute inset-0 flex items-center justify-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button
                        onClick={onLoad}
                        className="p-3 bg-white text-black rounded-full hover:scale-110 transition-transform shadow-lg"
                        title="Load into Scene"
                    >
                        <ExternalLink className="w-5 h-5" />
                    </button>
                </div>

                <div className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <button
                        onClick={(e) => { e.stopPropagation(); onRemove(); }}
                        className="p-2 bg-black/50 text-white rounded-full hover:bg-red-500/80 transition-colors backdrop-blur-sm"
                    >
                        <Trash2 className="w-4 h-4" />
                    </button>
                </div>

                {/* Type Badge */}
                <div className="absolute top-2 left-2 px-2 py-1 bg-black/60 backdrop-blur-sm rounded text-[10px] font-bold uppercase text-white border border-white/10">
                    {asset.type === 'image-to-3d' ? 'Image' : 'Model'}
                </div>
            </div>

            {/* Info */}
            <div className="p-4">
                <h3 className="font-medium text-white truncate" title={asset.name}>{asset.name}</h3>
                <p className="text-xs text-zinc-500 mt-1">
                    {new Date(asset.createdAt).toLocaleDateString()}
                </p>
            </div>
        </div>
    );
}
