import { Play, Pause, SkipBack, SkipForward, Repeat, Search } from 'lucide-react';
import { Button } from '../ui/Button';
import { Panel } from '../ui/Panel';
import { Input } from '../ui/Input';
import useStore from '../../store/useStore';
import { cn } from '../../lib/utils';

const ANIMATIONS = [
    { id: 'idle', label: 'Idle', category: 'Basic' },
    { id: 'walk', label: 'Walk', category: 'Locomotion' },
    { id: 'run', label: 'Run', category: 'Locomotion' },
    { id: 'jump', label: 'Jump', category: 'Action' },
    { id: 'dance', label: 'Dance', category: 'Emote' },
    { id: 'wave', label: 'Wave', category: 'Emote' },
];

export function AnimationPanel() {
    const animation = useStore((state) => state.animation);
    const updateAnimation = useStore((state) => state.updateAnimation);

    const togglePlay = () => {
        updateAnimation({ isPlaying: !animation.isPlaying });
    };

    return (
        <div className="flex-1 h-full bg-black p-8 overflow-y-auto flex gap-6">
            {/* Animation Library */}
            <div className="w-80 flex flex-col gap-4">
                <h2 className="text-xl font-bold text-white">Library</h2>
                <div className="relative">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-zinc-500" />
                    <Input placeholder="Search animations..." className="pl-9 bg-zinc-900 border-zinc-800" />
                </div>

                <div className="flex-1 bg-zinc-900/50 border border-zinc-800 rounded-lg overflow-y-auto p-2">
                    {ANIMATIONS.map((anim) => (
                        <button
                            key={anim.id}
                            onClick={() => updateAnimation({ currentAnimation: anim.id, isPlaying: true })}
                            className={cn(
                                "w-full text-left p-3 rounded-md flex justify-between items-center transition-colors mb-1",
                                animation.currentAnimation === anim.id
                                    ? "bg-blue-600 text-white"
                                    : "text-zinc-400 hover:bg-zinc-800 hover:text-zinc-200"
                            )}
                        >
                            <span className="font-medium">{anim.label}</span>
                            <span className={cn("text-xs", animation.currentAnimation === anim.id ? "text-blue-200" : "text-zinc-600")}>
                                {anim.category}
                            </span>
                        </button>
                    ))}
                </div>
            </div>

            {/* Timeline & Preview */}
            <div className="flex-1 flex flex-col gap-6">
                <div className="flex-1 bg-zinc-900 rounded-lg border border-zinc-800 flex items-center justify-center relative overflow-hidden">
                    {/* Mock 3D Preview Placeholder */}
                    <div className="text-zinc-600 flex flex-col items-center gap-2">
                        <Play className="w-12 h-12 opacity-20" />
                        <p>3D Preview Area</p>
                    </div>

                    {animation.currentAnimation && (
                        <div className="absolute bottom-4 left-4 bg-black/50 px-3 py-1 rounded text-xs text-white">
                            Playing: {ANIMATIONS.find(a => a.id === animation.currentAnimation)?.label}
                        </div>
                    )}
                </div>

                {/* Timeline Controls */}
                <Panel className="p-4 flex flex-col gap-4">
                    <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                            <Button onClick={() => updateAnimation({ loop: !animation.loop })} className={cn("p-2", animation.loop ? "text-blue-500" : "text-zinc-500")}>
                                <Repeat className="w-4 h-4" />
                            </Button>
                        </div>

                        <div className="flex items-center gap-4">
                            <Button className="text-zinc-400 hover:text-white"><SkipBack className="w-5 h-5" /></Button>
                            <Button
                                onClick={togglePlay}
                                className="w-12 h-12 rounded-full bg-white text-black hover:bg-zinc-200 flex items-center justify-center"
                            >
                                {animation.isPlaying ? <Pause className="w-5 h-5 fill-current" /> : <Play className="w-5 h-5 fill-current ml-1" />}
                            </Button>
                            <Button className="text-zinc-400 hover:text-white"><SkipForward className="w-5 h-5" /></Button>
                        </div>

                        <div className="w-24 text-right text-xs text-zinc-500 font-mono">
                            00:00 / 02:30
                        </div>
                    </div>

                    {/* Scrubber */}
                    <div className="relative w-full h-8 bg-zinc-900 rounded flex items-center px-2 cursor-pointer group">
                        <div className="absolute inset-x-0 h-1 bg-zinc-800 rounded overflow-hidden">
                            <div className="h-full bg-blue-600 w-1/3" />
                        </div>
                        <div className="absolute left-1/3 w-3 h-3 bg-white rounded-full shadow-lg transform -translate-x-1/2 opacity-0 group-hover:opacity-100 transition-opacity" />
                    </div>
                </Panel>
            </div>
        </div>
    );
}
