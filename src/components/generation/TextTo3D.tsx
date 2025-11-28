import { useState } from 'react';
import { Wand2, AlertCircle } from 'lucide-react';
import { Button } from '../ui/Button';
import { Panel } from '../ui/Panel';
import { Input } from '../ui/Input';
import useStore from '../../store/useStore';
import { cn } from '../../lib/utils';

const STYLES = [
    { id: 'realistic', label: 'Realistic', image: 'https://placehold.co/100x100/27272a/ffffff?text=Real' },
    { id: 'cartoon', label: 'Cartoon', image: 'https://placehold.co/100x100/27272a/ffffff?text=Toon' },
    { id: 'low-poly', label: 'Low Poly', image: 'https://placehold.co/100x100/27272a/ffffff?text=Poly' },
    { id: 'voxel', label: 'Voxel', image: 'https://placehold.co/100x100/27272a/ffffff?text=Voxel' },
];

export function TextTo3D() {
    const addAsset = useStore((state) => state.addAsset);
    const [prompt, setPrompt] = useState('');
    const [negativePrompt, setNegativePrompt] = useState('');
    const [selectedStyle, setSelectedStyle] = useState('realistic');
    const [isGenerating, setIsGenerating] = useState(false);

    const handleGenerate = () => {
        if (!prompt) return;

        setIsGenerating(true);

        // Simulate generation process
        setTimeout(() => {
            addAsset({
                id: crypto.randomUUID(),
                name: prompt.slice(0, 20) + (prompt.length > 20 ? '...' : ''),
                type: 'text-to-3d',
                status: 'ready',
                thumbnail: `https://placehold.co/400x400/18181b/ffffff?text=${selectedStyle}`,
                url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Binary/Duck.glb', // Placeholder
                createdAt: Date.now(),
            });
            setIsGenerating(false);
            setPrompt('');
        }, 2000);
    };

    return (
        <div className="flex-1 h-full bg-black p-8 overflow-y-auto flex justify-center">
            <div className="w-full max-w-3xl flex flex-col gap-8">

                <div className="flex flex-col gap-2">
                    <h1 className="text-3xl font-bold text-white tracking-tight flex items-center gap-3">
                        <Wand2 className="w-8 h-8 text-blue-500" />
                        Text to 3D
                    </h1>
                    <p className="text-zinc-500">Turn your text descriptions into 3D models in seconds.</p>
                </div>

                <Panel className="p-6 flex flex-col gap-6">
                    {/* Prompt Input */}
                    <div className="flex flex-col gap-2">
                        <label className="text-sm font-bold text-zinc-400 uppercase">Prompt</label>
                        <textarea
                            value={prompt}
                            onChange={(e) => setPrompt(e.target.value)}
                            placeholder="A futuristic sci-fi helmet with glowing neon lights..."
                            className="w-full h-32 bg-zinc-900/50 border border-zinc-800 rounded-md p-4 text-zinc-200 focus:outline-none focus:border-zinc-600 resize-none font-mono"
                        />
                    </div>

                    {/* Negative Prompt */}
                    <div className="flex flex-col gap-2">
                        <label className="text-sm font-bold text-zinc-400 uppercase">Negative Prompt</label>
                        <Input
                            value={negativePrompt}
                            onChange={(e) => setNegativePrompt(e.target.value)}
                            placeholder="low quality, blurry, distorted..."
                            className="w-full bg-zinc-900/50 border-zinc-800"
                        />
                    </div>

                    {/* Style Selector */}
                    <div className="flex flex-col gap-2">
                        <label className="text-sm font-bold text-zinc-400 uppercase">Art Style</label>
                        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
                            {STYLES.map((style) => (
                                <button
                                    key={style.id}
                                    onClick={() => setSelectedStyle(style.id)}
                                    className={cn(
                                        "relative aspect-square rounded-lg overflow-hidden border-2 transition-all",
                                        selectedStyle === style.id
                                            ? "border-blue-500 opacity-100"
                                            : "border-transparent opacity-60 hover:opacity-80"
                                    )}
                                >
                                    <img src={style.image} alt={style.label} className="w-full h-full object-cover" />
                                    <div className="absolute bottom-0 left-0 w-full p-2 bg-black/60 text-xs font-bold text-white text-center">
                                        {style.label}
                                    </div>
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Generate Button */}
                    <Button
                        onClick={handleGenerate}
                        disabled={!prompt || isGenerating}
                        className={cn(
                            "w-full py-4 text-lg font-bold uppercase tracking-widest transition-all",
                            isGenerating
                                ? "bg-zinc-800 text-zinc-500 cursor-not-allowed"
                                : "bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-900/20"
                        )}
                    >
                        {isGenerating ? 'Generating...' : 'Generate 3D Model'}
                    </Button>

                    <div className="flex items-center gap-2 text-xs text-zinc-600 justify-center">
                        <AlertCircle className="w-3 h-3" />
                        <span>Generations cost 10 credits. You have 100 credits remaining.</span>
                    </div>

                </Panel>
            </div>
        </div>
    );
}
