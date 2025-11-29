import { useState } from 'react';
import useStore from '../../store/useStore';
import { Viewport } from '../canvas/Viewport';
import { ViewportControls } from '../canvas/ViewportControls';
import { ViewportActions } from '../canvas/ViewportActions';
import { Button } from '../ui/Button';
import { cn } from '../../lib/utils';
import {
    Box,
    Wand2,
    Settings2,
    Sparkles,
    ArrowRight,
    RefreshCw,
    Pencil
} from 'lucide-react';

export function TextTo3D() {
    const [prompt, setPrompt] = useState('');
    const [isGenerating, setIsGenerating] = useState(false);
    const [selectedModel, setSelectedModel] = useState('triposr');
    const [assetName, setAssetName] = useState('Text to 3D Model');
    const [isRenaming, setIsRenaming] = useState(false);
    const addAsset = useStore((state) => state.addAsset);

    const handleGenerate = () => {
        if (!prompt) return;

        setIsGenerating(true);

        // Simulate generation
        setTimeout(() => {
            addAsset({
                id: crypto.randomUUID(),
                type: 'text-to-3d', // Reusing this type for now, ideally 'model-gen'
                name: prompt.slice(0, 20) + '...',
                thumbnail: 'https://images.unsplash.com/photo-1633412802994-5c058f151b66?q=80&w=2564&auto=format&fit=crop',
                createdAt: Date.now(),
                status: 'ready',
                url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Binary/Duck.glb'
            });
            setIsGenerating(false);
        }, 4000);
    };

    return (
        <div className="flex-1 h-full bg-[#050505] flex overflow-hidden relative font-sans text-zinc-100">
            {/* Center Area: Viewport & Bottom Bar */}
            <div className="flex-1 flex flex-col relative min-w-0">
                {/* Viewport (Full Screen) */}
                <div className="flex-1 relative bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-zinc-900/50 to-[#050505]">
                    <div className="absolute inset-0 flex items-center justify-center">
                        <Viewport />
                        <ViewportControls />
                        <ViewportActions />

                        {/* Empty State Overlay */}
                        {!prompt && !selectedModel && (
                            <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
                                <div className="text-center opacity-50">
                                    <Box className="w-16 h-16 text-zinc-700 mx-auto mb-4" />
                                    <h3 className="text-lg font-medium text-zinc-500">Ready to Generate</h3>
                                    <p className="text-sm text-zinc-600 mt-1">Enter a prompt to start creating 3D models</p>
                                </div>
                            </div>
                        )}
                    </div>

                    {/* Top Left: Back / Title / Renaming */}
                    <div className="absolute top-6 left-6 flex items-center gap-4 pointer-events-none z-20">
                        <div className="flex items-center gap-2 pointer-events-auto">
                            <div className="w-10 h-10 rounded-xl bg-zinc-900 border border-zinc-800 flex items-center justify-center">
                                <Box className="w-5 h-5 text-blue-500" />
                            </div>
                            <div className="flex items-center gap-2 group">
                                {isRenaming ? (
                                    <input
                                        value={assetName}
                                        onChange={(e) => setAssetName(e.target.value)}
                                        onBlur={() => setIsRenaming(false)}
                                        onKeyDown={(e) => e.key === 'Enter' && setIsRenaming(false)}
                                        autoFocus
                                        className="bg-transparent text-lg font-bold text-white focus:outline-none border-b border-blue-500 min-w-[100px]"
                                    />
                                ) : (
                                    <h1 className="text-lg font-bold text-white">{assetName}</h1>
                                )}
                                <button
                                    onClick={() => setIsRenaming(true)}
                                    className="opacity-0 group-hover:opacity-100 p-1 text-zinc-500 hover:text-white transition-opacity"
                                >
                                    <Pencil className="w-3 h-3" />
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Bottom Bar: Prompt Input */}
                <div className="h-auto p-6 z-10 pointer-events-none">
                    <div className="max-w-3xl mx-auto w-full pointer-events-auto">
                        <div className="bg-zinc-950/90 backdrop-blur-xl border border-zinc-800 rounded-2xl p-4 shadow-2xl shadow-black/50 flex flex-col gap-4">
                            {/* Prompt Header/Status */}
                            <div className="flex items-center gap-3 text-xs text-zinc-500 px-1">
                                <Sparkles className="w-3 h-3 text-blue-500" />
                                <span className="font-medium text-zinc-300">AI Prompt</span>
                                <span className="w-1 h-1 rounded-full bg-zinc-700" />
                                <span>Describe the object clearly</span>
                            </div>

                            {/* Input Area */}
                            <div className="flex gap-3 items-end">
                                <div className="flex-1 relative">
                                    <textarea
                                        value={prompt}
                                        onChange={(e) => setPrompt(e.target.value)}
                                        placeholder="Describe what you want to generate..."
                                        className="w-full bg-zinc-900/50 border border-zinc-800 rounded-xl p-3 text-sm text-white placeholder:text-zinc-600 focus:outline-none focus:border-blue-500/50 focus:bg-zinc-900 transition-all resize-none h-12 min-h-[48px] max-h-32 py-3"
                                        style={{ fieldSizing: 'content' } as any}
                                    />
                                </div>
                                <Button
                                    onClick={handleGenerate}
                                    disabled={!prompt || isGenerating}
                                    className={cn(
                                        "h-12 px-6 rounded-xl font-medium transition-all flex items-center gap-2 min-w-[120px] justify-center",
                                        isGenerating
                                            ? "bg-zinc-800 text-zinc-500 cursor-not-allowed"
                                            : "bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-900/20 hover:shadow-blue-900/40"
                                    )}
                                >
                                    {isGenerating ? (
                                        <Wand2 className="w-4 h-4 animate-spin" />
                                    ) : (
                                        <>
                                            Generate <ArrowRight className="w-4 h-4" />
                                        </>
                                    )}
                                </Button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Right Panel: Settings (320px) */}
            <div className="w-80 bg-[#09090b] border-l border-zinc-800 flex flex-col overflow-y-auto z-20">
                <div className="p-5 border-b border-zinc-800">
                    <h2 className="text-sm font-bold text-white flex items-center gap-2">
                        <Settings2 className="w-4 h-4 text-zinc-400" />
                        Configuration
                    </h2>
                </div>

                <div className="p-5 flex flex-col gap-8">
                    {/* Art Style Selection */}
                    <div className="flex flex-col gap-3">
                        <div className="flex items-center justify-between">
                            <label className="text-xs font-bold text-zinc-400 uppercase tracking-wider">Art Style</label>
                        </div>
                        <div className="grid grid-cols-2 gap-2">
                            {['Realistic', 'Cartoon', 'Low Poly', 'Voxel'].map((style) => (
                                <button
                                    key={style}
                                    className="p-3 rounded-xl border border-zinc-800 bg-zinc-900/30 text-left transition-all hover:border-zinc-700 hover:bg-zinc-900/50 flex flex-col gap-2"
                                >
                                    <div className="w-8 h-8 rounded bg-zinc-800 flex items-center justify-center">
                                        <Box className="w-4 h-4 text-zinc-500" />
                                    </div>
                                    <span className="text-xs font-medium text-zinc-300">{style}</span>
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Model Settings */}
                    <div className="flex flex-col gap-4 pt-4 border-t border-zinc-800">
                        <div className="flex flex-col gap-2">
                            <div className="flex items-center justify-between">
                                <label className="text-xs text-zinc-300">Negative Prompt</label>
                            </div>
                            <textarea
                                className="w-full bg-zinc-900 border border-zinc-800 rounded-lg p-2 text-xs text-zinc-300 placeholder:text-zinc-600 resize-none h-20 focus:outline-none focus:border-zinc-700"
                                placeholder="What to avoid..."
                            />
                        </div>

                        <div className="flex items-center justify-between">
                            <label className="text-xs text-zinc-300">Seed</label>
                            <div className="flex items-center gap-2">
                                <input type="number" className="w-20 bg-zinc-900 border border-zinc-800 rounded p-1 text-xs text-zinc-300 text-right focus:outline-none" placeholder="-1" />
                                <button className="p-1 rounded hover:bg-zinc-800 text-zinc-500">
                                    <RefreshCw className="w-3 h-3" />
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Bottom Action */}
                <div className="mt-auto p-5 border-t border-zinc-800 bg-zinc-900/30">
                    <Button className="w-full py-4 bg-white text-black hover:bg-zinc-200 font-bold rounded-xl flex items-center justify-center gap-2 transition-all">
                        <Wand2 className="w-4 h-4" />
                        Generate 3D Mesh
                    </Button>
                    <div className="text-center mt-3">
                        <span className="text-[10px] text-zinc-500">Cost: 15 credits</span>
                    </div>
                </div>
            </div>
        </div>
    );
}
