import { useState } from 'react';
import { Panel } from '../ui/Panel';
import { Button } from '../ui/Button';
import { Wand2, Layers, Palette, Sparkles, Camera } from 'lucide-react';
import { cn } from '../../lib/utils';
import useStore from '../../store/useStore';

export function AIEditPanel() {
    const [isProcessing, setIsProcessing] = useState(false);
    const [activeAction, setActiveAction] = useState<string | null>(null);
    const setCapturePending = useStore((state) => state.setCapturePending);
    const selectedId = useStore((state) => state.selectedId);

    const handleAction = (action: string) => {
        setActiveAction(action);
        setIsProcessing(true);

        // Simulate processing
        setTimeout(() => {
            setIsProcessing(false);
            setActiveAction(null);
        }, 3000);
    };

    if (!selectedId) {
        return (
            <div className="flex flex-col items-center justify-center h-full text-zinc-500 p-8 text-center gap-4">
                <Sparkles className="w-8 h-8 opacity-20" />
                <p className="text-sm">Select an object in the scene to access AI tools.</p>
            </div>
        );
    }

    return (
        <div className="flex flex-col gap-4 p-4 h-full overflow-y-auto">
            <div className="flex items-center gap-2 border-b border-zinc-800 pb-2">
                <Sparkles className="w-4 h-4 text-blue-500" />
                <h2 className="text-xs font-bold text-zinc-500 uppercase tracking-widest">
                    AI Modification
                </h2>
            </div>

            <Panel className="p-4 flex flex-col gap-4">
                <div className="flex flex-col gap-2">
                    <h3 className="text-sm font-bold text-white flex items-center gap-2">
                        <Camera className="w-4 h-4" /> Thumbnail
                    </h3>
                    <p className="text-xs text-zinc-500">Update library preview with current view.</p>
                    <Button
                        onClick={() => setCapturePending(true)}
                        className="w-full justify-center gap-2 bg-zinc-800 text-zinc-300 hover:bg-zinc-700 hover:text-white transition-all"
                    >
                        <Camera className="w-4 h-4" /> Capture Snapshot
                    </Button>
                </div>

                <div className="w-full h-px bg-zinc-800" />

                <div className="flex flex-col gap-2">
                    <h3 className="text-sm font-bold text-white flex items-center gap-2">
                        <Layers className="w-4 h-4" /> Geometry
                    </h3>
                    <p className="text-xs text-zinc-500">Optimize and restructure mesh topology.</p>

                    <Button
                        onClick={() => handleAction('remesh')}
                        disabled={isProcessing}
                        className={cn(
                            "w-full justify-center gap-2 transition-all",
                            activeAction === 'remesh' ? "bg-blue-600 text-white" : "bg-zinc-800 text-zinc-300 hover:bg-zinc-700"
                        )}
                    >
                        {activeAction === 'remesh' ? (
                            <Wand2 className="w-4 h-4 animate-spin" />
                        ) : (
                            <Layers className="w-4 h-4" />
                        )}
                        {activeAction === 'remesh' ? 'Remeshing...' : 'Remesh Object'}
                    </Button>
                </div>

                <div className="w-full h-px bg-zinc-800" />

                <div className="flex flex-col gap-2">
                    <h3 className="text-sm font-bold text-white flex items-center gap-2">
                        <Palette className="w-4 h-4" /> Texture
                    </h3>
                    <p className="text-xs text-zinc-500">Generate or modify object textures.</p>

                    <Button
                        onClick={() => handleAction('retexture')}
                        disabled={isProcessing}
                        className={cn(
                            "w-full justify-center gap-2 transition-all",
                            activeAction === 'retexture' ? "bg-purple-600 text-white" : "bg-zinc-800 text-zinc-300 hover:bg-zinc-700"
                        )}
                    >
                        {activeAction === 'retexture' ? (
                            <Wand2 className="w-4 h-4 animate-spin" />
                        ) : (
                            <Palette className="w-4 h-4" />
                        )}
                        {activeAction === 'retexture' ? 'Generating...' : 'AI Retexture'}
                    </Button>
                </div>
            </Panel>

            <div className="mt-auto p-4 bg-blue-500/10 border border-blue-500/20 rounded-lg">
                <p className="text-xs text-blue-200 flex gap-2">
                    <Sparkles className="w-4 h-4 shrink-0" />
                    AI modifications are non-destructive and will create a new version of your asset.
                </p>
            </div>
        </div>
    );
}
