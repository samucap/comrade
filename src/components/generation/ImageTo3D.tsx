import { useState, useRef } from 'react';
import { Image as ImageIcon, Upload, AlertCircle, X } from 'lucide-react';
import { Button } from '../ui/Button';
import { Panel } from '../ui/Panel';
import useStore from '../../store/useStore';
import { cn } from '../../lib/utils';

export function ImageTo3D() {
    const addAsset = useStore((state) => state.addAsset);
    const [image, setImage] = useState<string | null>(null);
    const [isGenerating, setIsGenerating] = useState(false);
    const fileInputRef = useRef<HTMLInputElement>(null);

    const handleUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;
        const url = URL.createObjectURL(file);
        setImage(url);
    };

    const handleGenerate = () => {
        if (!image) return;

        setIsGenerating(true);

        // Simulate generation process
        setTimeout(() => {
            addAsset({
                id: crypto.randomUUID(),
                name: `Image Gen #${Math.floor(Math.random() * 1000)}`,
                type: 'image-to-3d',
                status: 'ready',
                thumbnail: image,
                url: 'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Binary/Duck.glb', // Placeholder
                createdAt: Date.now(),
            });
            setIsGenerating(false);
            setImage(null);
        }, 2000);
    };

    return (
        <div className="flex-1 h-full bg-black p-8 overflow-y-auto flex justify-center">
            <div className="w-full max-w-3xl flex flex-col gap-8">

                <div className="flex flex-col gap-2">
                    <h1 className="text-3xl font-bold text-white tracking-tight flex items-center gap-3">
                        <ImageIcon className="w-8 h-8 text-purple-500" />
                        Image to 3D
                    </h1>
                    <p className="text-zinc-500">Transform your 2D images into high-quality 3D models.</p>
                </div>

                <Panel className="p-6 flex flex-col gap-6">

                    {/* Image Uploader */}
                    <div className="flex flex-col gap-2">
                        <label className="text-sm font-bold text-zinc-400 uppercase">Reference Image</label>

                        {!image ? (
                            <div
                                onClick={() => fileInputRef.current?.click()}
                                className="w-full h-64 border-2 border-dashed border-zinc-800 rounded-lg flex flex-col items-center justify-center gap-4 cursor-pointer hover:border-zinc-600 hover:bg-zinc-900/50 transition-all"
                            >
                                <Upload className="w-12 h-12 text-zinc-600" />
                                <div className="text-center">
                                    <p className="text-zinc-300 font-medium">Click to upload or drag and drop</p>
                                    <p className="text-zinc-600 text-sm">PNG, JPG up to 10MB</p>
                                </div>
                            </div>
                        ) : (
                            <div className="relative w-full h-64 bg-zinc-900 rounded-lg overflow-hidden border border-zinc-800 group">
                                <img src={image} alt="Reference" className="w-full h-full object-contain" />
                                <button
                                    onClick={() => setImage(null)}
                                    className="absolute top-2 right-2 p-2 bg-black/50 text-white rounded-full hover:bg-red-500 transition-colors"
                                >
                                    <X className="w-4 h-4" />
                                </button>
                            </div>
                        )}
                        <input
                            type="file"
                            ref={fileInputRef}
                            onChange={handleUpload}
                            accept="image/*"
                            className="hidden"
                        />
                    </div>

                    {/* Generate Button */}
                    <Button
                        onClick={handleGenerate}
                        disabled={!image || isGenerating}
                        className={cn(
                            "w-full py-4 text-lg font-bold uppercase tracking-widest transition-all",
                            isGenerating
                                ? "bg-zinc-800 text-zinc-500 cursor-not-allowed"
                                : "bg-purple-600 hover:bg-purple-500 text-white shadow-lg shadow-purple-900/20"
                        )}
                    >
                        {isGenerating ? 'Generating...' : 'Generate 3D Model'}
                    </Button>

                    <div className="flex items-center gap-2 text-xs text-zinc-600 justify-center">
                        <AlertCircle className="w-3 h-3" />
                        <span>Generations cost 20 credits. You have 100 credits remaining.</span>
                    </div>

                </Panel>
            </div>
        </div>
    );
}
