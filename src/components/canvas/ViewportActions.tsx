import {
    Palette,
    ArrowRight,
    Zap,
    Box,
    Upload,
    Settings2,
    Share2,
    Accessibility
} from 'lucide-react';
import { Button } from '../ui/Button';

export function ViewportActions() {
    return (
        <div className="absolute bottom-8 left-1/2 -translate-x-1/2 flex items-center gap-2 pointer-events-auto z-20">
            <div className="flex items-center gap-1 p-1.5 bg-zinc-950/90 backdrop-blur-xl border border-zinc-800 rounded-xl shadow-2xl shadow-black/50">
                <Button className="h-9 px-4 bg-purple-500/10 hover:bg-purple-500/20 text-purple-400 border border-purple-500/20 rounded-lg text-xs font-medium flex items-center gap-2">
                    <Palette className="w-3 h-3" /> AI Texture
                </Button>
                <Button className="h-9 px-4 bg-zinc-900 hover:bg-zinc-800 text-zinc-300 border border-zinc-800 rounded-lg text-xs font-medium flex items-center gap-2">
                    <ArrowRight className="w-3 h-3 -rotate-45" /> Upres
                    <span className="bg-zinc-800 px-1 rounded text-[9px] text-zinc-500">3</span>
                </Button>
                <Button className="h-9 px-4 bg-orange-500/10 hover:bg-orange-500/20 text-orange-400 border border-orange-500/20 rounded-lg text-xs font-medium flex items-center gap-2">
                    <Accessibility className="w-3 h-3" /> AI Animate
                </Button>
                <Button className="h-9 px-4 bg-orange-500/10 hover:bg-orange-500/20 text-orange-400 border border-orange-500/20 rounded-lg text-xs font-medium flex items-center gap-2">
                    <Share2 className="w-3 h-3" /> AI Retopology
                </Button>
                <div className="w-px h-6 bg-zinc-800 mx-1" />
                <Button className="w-9 h-9 p-0 bg-zinc-900 hover:bg-zinc-800 text-zinc-400 border border-zinc-800 rounded-lg flex items-center justify-center">
                    <Upload className="w-4 h-4 rotate-180" />
                </Button>
                <Button className="w-9 h-9 p-0 bg-zinc-900 hover:bg-zinc-800 text-zinc-400 border border-zinc-800 rounded-lg flex items-center justify-center">
                    <Settings2 className="w-4 h-4" />
                </Button>
            </div>

            {/* Feedback Toast */}
            <div className="absolute -top-12 left-1/2 -translate-x-1/2 bg-zinc-900 text-zinc-400 text-xs px-3 py-1.5 rounded-full border border-zinc-800 flex items-center gap-2 whitespace-nowrap">
                How's the mesh?
                <div className="flex gap-1 ml-1">
                    <button className="hover:text-white"><Zap className="w-3 h-3" /></button>
                    <button className="hover:text-white"><Zap className="w-3 h-3 rotate-180" /></button>
                </div>
            </div>
        </div>
    );
}
