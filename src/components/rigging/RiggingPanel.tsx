import { useState } from 'react';
import { PersonStanding, Check, AlertCircle } from 'lucide-react';
import { Button } from '../ui/Button';
import { Panel } from '../ui/Panel';
import useStore from '../../store/useStore';
import { cn } from '../../lib/utils';

export function RiggingPanel() {
    const [isRigging, setIsRigging] = useState(false);
    const [riggingComplete, setRiggingComplete] = useState(false);
    const selectedId = useStore((state) => state.selectedId);
    const setView = useStore((state) => state.setView);

    const handleAutoRig = () => {
        setIsRigging(true);
        setTimeout(() => {
            setIsRigging(false);
            setRiggingComplete(true);
        }, 3000);
    };

    return (
        <div className="flex-1 h-full bg-black p-8 overflow-y-auto flex justify-center">
            <div className="w-full max-w-3xl flex flex-col gap-8">

                <div className="flex flex-col gap-2">
                    <h1 className="text-3xl font-bold text-white tracking-tight flex items-center gap-3">
                        <PersonStanding className="w-8 h-8 text-green-500" />
                        Auto-Rigging
                    </h1>
                    <p className="text-zinc-500">Automatically rig your 3D models for animation.</p>
                </div>

                <Panel className="p-6 flex flex-col gap-6 items-center text-center">
                    {!selectedId ? (
                        <div className="py-12 flex flex-col items-center gap-4 text-zinc-500">
                            <AlertCircle className="w-12 h-12" />
                            <p>Please select a model in the Editor to rig.</p>
                            <Button onClick={() => setView('editor')} className="bg-zinc-800 text-white hover:bg-zinc-700">
                                Go to Editor
                            </Button>
                        </div>
                    ) : riggingComplete ? (
                        <div className="py-12 flex flex-col items-center gap-6">
                            <div className="w-20 h-20 bg-green-500/20 rounded-full flex items-center justify-center">
                                <Check className="w-10 h-10 text-green-500" />
                            </div>
                            <div className="flex flex-col gap-2">
                                <h2 className="text-2xl font-bold text-white">Rigging Complete!</h2>
                                <p className="text-zinc-400">Your model is now ready for animation.</p>
                            </div>
                            <Button
                                onClick={() => setView('animation')}
                                className="bg-blue-600 hover:bg-blue-500 text-white px-8 py-3 text-lg"
                            >
                                Go to Animation
                            </Button>
                        </div>
                    ) : (
                        <div className="w-full py-12 flex flex-col items-center gap-8">
                            <div className="relative w-64 h-64 bg-zinc-900 rounded-lg border border-zinc-800 flex items-center justify-center overflow-hidden">
                                {isRigging && (
                                    <div className="absolute inset-0 bg-green-500/10 animate-pulse flex items-center justify-center">
                                        <span className="text-green-500 font-mono animate-bounce">Processing...</span>
                                    </div>
                                )}
                                <PersonStanding className="w-32 h-32 text-zinc-700" />
                            </div>

                            <div className="flex flex-col gap-2 max-w-md">
                                <h3 className="text-xl font-bold text-white">Ready to Rig</h3>
                                <p className="text-zinc-500 text-sm">
                                    Our AI will automatically detect joints and skin weights for your character.
                                    Best results with T-pose or A-pose models.
                                </p>
                            </div>

                            <Button
                                onClick={handleAutoRig}
                                disabled={isRigging}
                                className={cn(
                                    "w-full max-w-sm py-4 text-lg font-bold uppercase tracking-widest transition-all",
                                    isRigging
                                        ? "bg-zinc-800 text-zinc-500 cursor-not-allowed"
                                        : "bg-green-600 hover:bg-green-500 text-white shadow-lg shadow-green-900/20"
                                )}
                            >
                                {isRigging ? 'Rigging Model...' : 'Start Auto-Rigging'}
                            </Button>
                        </div>
                    )}
                </Panel>
            </div>
        </div>
    );
}
