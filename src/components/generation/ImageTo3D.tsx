import { useState } from 'react';
import { Upload, ImageIcon, Wand2, Settings2, Layers, Ratio } from 'lucide-react';
import { Button } from '../ui/Button';
import { Panel } from '../ui/Panel';
import useStore from '../../store/useStore';
import { cn } from '../../lib/utils';

export function ImageTo3D() {
    const [prompt, setPrompt] = useState('');
    const [isGenerating, setIsGenerating] = useState(false);
    const [selectedModel, setSelectedModel] = useState('sdxl');
    const [aspectRatio, setAspectRatio] = useState('1:1');
    const [imageStrength, setImageStrength] = useState(0.7);
    const addAsset = useStore((state) => state.addAsset);

    const handleGenerate = () => {
        if (!prompt) return;

        setIsGenerating(true);

        // Simulate generation
        setTimeout(() => {
            addAsset({
                id: crypto.randomUUID(),
                type: 'image-to-3d', // Reusing this type for now, ideally 'image-gen'
                name: prompt.slice(0, 20) + '...',
                thumbnail: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop',
                createdAt: Date.now(),
                status: 'ready',
                url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Binary/Duck.glb'
            });
            setIsGenerating(false);
        }, 2000);
    };

    return (
        <div className="flex-1 h-full bg-black p-8 overflow-y-auto flex justify-center">
            <div className="w-full max-w-3xl flex flex-col gap-8">

                <div className="flex flex-col gap-2">
                    <h1 className="text-3xl font-bold text-white tracking-tight flex items-center gap-3">
                        <ImageIcon className="w-8 h-8 text-purple-500" />
                        Image Generation
                    </h1>
                    <p className="text-zinc-500">Generate high-quality images from text prompts using advanced AI models.</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    {/* Left Column: Controls */}
                    <div className="md:col-span-2 flex flex-col gap-6">
                        <Panel className="p-6 flex flex-col gap-6">
                            <div className="flex flex-col gap-2">
                                <label className="text-sm font-medium text-zinc-400">Prompt</label>
                                <textarea
                                    className="w-full h-32 bg-zinc-900 border border-zinc-800 rounded-lg p-3 text-white placeholder:text-zinc-600 focus:outline-none focus:border-purple-500 resize-none"
                                    placeholder="Describe the image you want to generate..."
                                    value={prompt}
                                    onChange={(e) => setPrompt(e.target.value)}
                                />
                            </div>

                            <div className="flex flex-col gap-2">
                                <label className="text-sm font-medium text-zinc-400">AI Model</label>
                                <div className="grid grid-cols-2 gap-2">
                                    {['SDXL', 'Midjourney', 'DALL-E 3', 'ControlNet'].map((model) => (
                                        <button
                                            key={model}
                                            onClick={() => setSelectedModel(model.toLowerCase())}
                                            className={cn(
                                                "p-3 rounded-lg border text-sm font-medium transition-all text-left",
                                                selectedModel === model.toLowerCase()
                                                    ? "border-purple-500 bg-purple-500/10 text-white"
                                                    : "border-zinc-800 bg-zinc-900/50 text-zinc-400 hover:border-zinc-700"
                                            )}
                                        >
                                            {model}
                                        </button>
                                    ))}
                                </div>
                            </div>

                            <div className="flex flex-col gap-4">
                                <div className="flex items-center justify-between">
                                    <label className="text-sm font-medium text-zinc-400 flex items-center gap-2">
                                        <Upload className="w-4 h-4" /> Reference Image
                                    </label>
                                    <span className="text-xs text-zinc-600">Optional</span>
                                </div>
                                <div className="border-2 border-dashed border-zinc-800 rounded-lg p-8 flex flex-col items-center gap-2 text-zinc-500 hover:border-zinc-700 hover:bg-zinc-900/50 transition-colors cursor-pointer">
                                    <Upload className="w-8 h-8" />
                                    <p className="text-sm">Drop image or click to upload</p>
                                </div>

                                <div className="flex flex-col gap-2">
                                    <div className="flex justify-between text-xs text-zinc-500">
                                        <span>Image Strength</span>
                                        <span>{Math.round(imageStrength * 100)}%</span>
                                    </div>
                                    <input
                                        type="range"
                                        min="0"
                                        max="1"
                                        step="0.1"
                                        value={imageStrength}
                                        onChange={(e) => setImageStrength(parseFloat(e.target.value))}
                                        className="w-full accent-purple-500"
                                    />
                                </div>
                            </div>

                            <Button
                                onClick={handleGenerate}
                                disabled={!prompt || isGenerating}
                                className={cn(
                                    "w-full py-4 text-lg font-bold uppercase tracking-widest transition-all",
                                    isGenerating
                                        ? "bg-zinc-800 text-zinc-500 cursor-not-allowed"
                                        : "bg-purple-600 hover:bg-purple-500 text-white shadow-lg shadow-purple-900/20"
                                )}
                            >
                                {isGenerating ? (
                                    <span className="flex items-center justify-center gap-2">
                                        <Wand2 className="w-5 h-5 animate-spin" /> Generating...
                                    </span>
                                ) : (
                                    <span className="flex items-center justify-center gap-2">
                                        <Wand2 className="w-5 h-5" /> Generate Image
                                    </span>
                                )}
                            </Button>
                        </Panel>
                    </div>

                    {/* Right Column: Settings */}
                    <div className="flex flex-col gap-6">
                        <Panel className="p-6 flex flex-col gap-6">
                            <h3 className="text-lg font-bold text-white flex items-center gap-2">
                                <Settings2 className="w-5 h-5" /> Settings
                            </h3>

                            <div className="flex flex-col gap-3">
                                <label className="text-sm font-medium text-zinc-400 flex items-center gap-2">
                                    <Ratio className="w-4 h-4" /> Aspect Ratio
                                </label>
                                <div className="grid grid-cols-3 gap-2">
                                    {['1:1', '16:9', '9:16', '4:3', '3:4'].map((ratio) => (
                                        <button
                                            key={ratio}
                                            onClick={() => setAspectRatio(ratio)}
                                            className={cn(
                                                "p-2 rounded border text-xs font-medium transition-all",
                                                aspectRatio === ratio
                                                    ? "border-purple-500 bg-purple-500/10 text-white"
                                                    : "border-zinc-800 bg-zinc-900/50 text-zinc-400 hover:border-zinc-700"
                                            )}
                                        >
                                            {ratio}
                                        </button>
                                    ))}
                                </div>
                            </div>

                            <div className="flex flex-col gap-3">
                                <label className="text-sm font-medium text-zinc-400 flex items-center gap-2">
                                    <Layers className="w-4 h-4" /> Multi-View
                                </label>
                                <div className="flex items-center gap-2 p-2 bg-zinc-900 rounded border border-zinc-800">
                                    <input type="checkbox" className="accent-purple-500 w-4 h-4" />
                                    <span className="text-sm text-zinc-300">Generate 4 views</span>
                                </div>
                            </div>

                            <div className="flex flex-col gap-3">
                                <label className="text-sm font-medium text-zinc-400">Pose</label>
                                <div className="grid grid-cols-2 gap-2">
                                    <button className="p-2 rounded border border-zinc-800 bg-zinc-900 text-zinc-400 text-xs hover:text-white">A-Pose</button>
                                    <button className="p-2 rounded border border-zinc-800 bg-zinc-900 text-zinc-400 text-xs hover:text-white">T-Pose</button>
                                </div>
                            </div>

                        </Panel>
                    </div>
                </div>
            </div>
        </div>
    );
}
