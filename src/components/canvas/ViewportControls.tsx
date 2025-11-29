import { useState, useRef } from 'react';
import {
    Box,
    Grid,
    RotateCw,
    RefreshCcw,
    Move,
    Maximize,
    Image as ImageIcon,
    Upload,
    LayoutGrid
} from 'lucide-react';
import { Button } from '../ui/Button';
import { Tooltip } from '../ui/Tooltip';
import useStore from '../../store/useStore';
import { cn } from '../../lib/utils';

export function ViewportControls() {
    const renderMode = useStore((state) => state.renderMode);
    const setRenderMode = useStore((state) => state.setRenderMode);
    const environment = useStore((state) => state.environment);
    const updateEnvironment = useStore((state) => state.updateEnvironment);
    const transformMode = useStore((state) => state.transformMode);
    const setTransformMode = useStore((state) => state.setTransformMode);

    const [showEnvMenu, setShowEnvMenu] = useState(false);
    const fileInputRef = useRef<HTMLInputElement>(null);

    const handleEnvUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = (e) => {
            const result = e.target?.result as string;
            if (result) {
                updateEnvironment({ scenery: result });
                setShowEnvMenu(false);
            }
        };
        reader.readAsDataURL(file);
    };

    return (
        <>
            {/* Top Right: Global View Controls */}
            <div className="absolute right-4 top-4 flex gap-2 pointer-events-auto z-30">
                <div className="p-1.5 bg-zinc-950/90 backdrop-blur-xl border border-zinc-800 rounded-xl flex items-center gap-1 shadow-xl">
                    <ControlButton
                        active={environment.gridVisible}
                        onClick={() => updateEnvironment({ gridVisible: !environment.gridVisible })}
                        icon={<LayoutGrid className="w-4 h-4" />}
                        label="Toggle Grid"
                    />
                    <ControlButton
                        active={false}
                        onClick={() => { /* Reset Camera Logic */ }}
                        icon={<RefreshCcw className="w-4 h-4" />}
                        label="Reset View"
                    />

                    <div className="w-px h-4 bg-zinc-800 mx-1" />

                    <div className="relative">
                        <ControlButton
                            active={showEnvMenu || environment.scenery !== 'none'}
                            onClick={() => setShowEnvMenu(!showEnvMenu)}
                            icon={<ImageIcon className="w-4 h-4" />}
                            label="Display & Environment"
                        />

                        {showEnvMenu && (
                            <div className="absolute top-full right-0 mt-2 w-56 bg-zinc-900 border border-zinc-800 rounded-xl shadow-2xl overflow-hidden flex flex-col p-1 z-50">
                                <div className="px-3 py-2 text-[10px] font-bold text-zinc-500 uppercase tracking-wider">Render Mode</div>
                                <div className="flex gap-1 px-1">
                                    <Button
                                        onClick={() => setRenderMode('pbr')}
                                        className={cn("flex-1 text-xs h-7", renderMode === 'pbr' ? "bg-zinc-800 text-white" : "text-zinc-400 hover:text-white")}
                                    >
                                        PBR
                                    </Button>
                                    <Button
                                        onClick={() => setRenderMode('matcap')}
                                        className={cn("flex-1 text-xs h-7", renderMode === 'matcap' ? "bg-zinc-800 text-white" : "text-zinc-400 hover:text-white")}
                                    >
                                        Matcap
                                    </Button>
                                    <Button
                                        onClick={() => setRenderMode('wireframe')}
                                        className={cn("flex-1 text-xs h-7", renderMode === 'wireframe' ? "bg-zinc-800 text-white" : "text-zinc-400 hover:text-white")}
                                    >
                                        Wire
                                    </Button>
                                </div>

                                <div className="h-px bg-zinc-800 my-2" />

                                <div className="px-3 py-1 text-[10px] font-bold text-zinc-500 uppercase tracking-wider flex justify-between items-center">
                                    <span>Lighting</span>
                                    <span className="text-white">{environment.lightIntensity}x</span>
                                </div>
                                <div className="px-2 pb-2">
                                    <input
                                        type="range"
                                        min="0"
                                        max="3"
                                        step="0.1"
                                        value={environment.lightIntensity}
                                        onChange={(e) => updateEnvironment({ lightIntensity: parseFloat(e.target.value) })}
                                        className="w-full h-1 bg-zinc-800 rounded-lg appearance-none cursor-pointer accent-blue-500"
                                    />
                                </div>

                                <div className="h-px bg-zinc-800 my-1" />

                                <div className="px-3 py-2 text-[10px] font-bold text-zinc-500 uppercase tracking-wider">Environment</div>
                                <EnvOption label="None" active={environment.scenery === 'none'} onClick={() => updateEnvironment({ scenery: 'none' })} />
                                <EnvOption label="City" active={environment.scenery === 'city'} onClick={() => updateEnvironment({ scenery: 'city' })} />
                                <EnvOption label="Nature" active={environment.scenery === 'nature'} onClick={() => updateEnvironment({ scenery: 'nature' })} />
                                <EnvOption label="Studio" active={environment.scenery === 'studio'} onClick={() => updateEnvironment({ scenery: 'studio' })} />
                                <div className="h-px bg-zinc-800 my-1" />
                                <button
                                    onClick={() => fileInputRef.current?.click()}
                                    className="flex items-center gap-2 px-3 py-2 text-xs font-medium text-zinc-400 hover:text-white hover:bg-zinc-800 rounded-lg transition-colors w-full text-left"
                                >
                                    <Upload className="w-3 h-3" />
                                    Import Environment...
                                </button>
                            </div>
                        )}
                    </div>
                </div>
            </div>

            <input
                type="file"
                ref={fileInputRef}
                onChange={handleEnvUpload}
                accept=".hdr,.exr,.jpg,.png"
                className="hidden"
            />

            {/* Center Left: Display Toggles - Removed as moved to top right */}
            {/* <div className="absolute left-4 top-1/2 -translate-y-1/2 flex flex-col gap-2 pointer-events-auto z-30"> ... </div> */}

            {/* Bottom Left: Transform Controls */}
            <div className="absolute left-4 bottom-8 pointer-events-auto z-30">
                <div className="p-1.5 bg-zinc-950/90 backdrop-blur-xl border border-zinc-800 rounded-xl flex items-center gap-1 shadow-xl">
                    <ControlButton
                        active={transformMode === 'translate'}
                        onClick={() => setTransformMode('translate')}
                        icon={<Move className="w-4 h-4" />}
                        label="Translate"
                    />
                    <ControlButton
                        active={transformMode === 'rotate'}
                        onClick={() => setTransformMode('rotate')}
                        icon={<RotateCw className="w-4 h-4" />}
                        label="Rotate"
                    />
                    <ControlButton
                        active={transformMode === 'scale'}
                        onClick={() => setTransformMode('scale')}
                        icon={<Maximize className="w-4 h-4" />}
                        label="Scale"
                    />
                </div>
            </div>
        </>
    );
}

function ControlButton({ active, onClick, icon, label }: { active: boolean, onClick: () => void, icon: React.ReactNode, label: string }) {
    return (
        <Tooltip content={label} side="right">
            <Button
                onClick={onClick}
                className={cn(
                    "w-8 h-8 p-0 flex items-center justify-center rounded-lg transition-all",
                    active
                        ? "bg-blue-600 text-white shadow-lg shadow-blue-900/20"
                        : "text-zinc-400 hover:bg-zinc-800 hover:text-zinc-200"
                )}
            >
                {icon}
            </Button>
        </Tooltip>
    );
}

function EnvOption({ label, active, onClick }: { label: string, active: boolean, onClick: () => void }) {
    return (
        <button
            onClick={onClick}
            className={cn(
                "px-3 py-2 text-xs font-medium rounded-lg transition-colors w-full text-left",
                active ? "bg-blue-600 text-white" : "text-zinc-400 hover:text-white hover:bg-zinc-800"
            )}
        >
            {label}
        </button>
    );
}
