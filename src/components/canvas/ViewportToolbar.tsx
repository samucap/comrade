import { Box, Grid, Layers, Sun, Eye, EyeOff } from 'lucide-react';
import { Button } from '../ui/Button';
import { Panel } from '../ui/Panel';
import { Tooltip } from '../ui/Tooltip';
import useStore from '../../store/useStore';
import { cn } from '../../lib/utils';

export function ViewportToolbar() {
    const renderMode = useStore((state) => state.renderMode);
    const setRenderMode = useStore((state) => state.setRenderMode);
    const environment = useStore((state) => state.environment);
    const updateEnvironment = useStore((state) => state.updateEnvironment);

    return (
        <div className="absolute top-4 left-1/2 -translate-x-1/2 pointer-events-auto">
            <Panel className="p-1 flex items-center gap-2">
                {/* Render Modes */}
                <div className="flex gap-1">
                    <ModeButton
                        active={renderMode === 'pbr'}
                        onClick={() => setRenderMode('pbr')}
                        icon={<Box className="w-4 h-4" />}
                        label="PBR Render"
                    />
                    <ModeButton
                        active={renderMode === 'wireframe'}
                        onClick={() => setRenderMode('wireframe')}
                        icon={<Grid className="w-4 h-4" />}
                        label="Wireframe"
                    />
                    <ModeButton
                        active={renderMode === 'matcap'}
                        onClick={() => setRenderMode('matcap')}
                        icon={<Layers className="w-4 h-4" />}
                        label="Matcap"
                    />
                </div>

                <div className="w-px h-4 bg-zinc-800 mx-1" />

                {/* Environment Controls */}
                <div className="flex gap-1">
                    <Tooltip content="Toggle Grid">
                        <Button
                            onClick={() => updateEnvironment({ gridVisible: !environment.gridVisible })}
                            className={cn("p-2", environment.gridVisible ? "text-white" : "text-zinc-600")}
                        >
                            {environment.gridVisible ? <Eye className="w-4 h-4" /> : <EyeOff className="w-4 h-4" />}
                        </Button>
                    </Tooltip>

                    <Tooltip content="Light Intensity">
                        <Button
                            onClick={() => updateEnvironment({ lightIntensity: environment.lightIntensity > 1 ? 0.5 : environment.lightIntensity + 0.5 })}
                            className="p-2 text-zinc-400 hover:text-white"
                        >
                            <Sun className="w-4 h-4" />
                            <span className="ml-1 text-[10px] font-mono">{environment.lightIntensity}x</span>
                        </Button>
                    </Tooltip>
                </div>

                <div className="w-px h-4 bg-zinc-800 mx-1" />

                {/* Scenery Controls */}
                <div className="flex gap-1">
                    <ModeButton
                        active={environment.scenery === 'none'}
                        onClick={() => updateEnvironment({ scenery: 'none' })}
                        icon={<span className="text-[10px] font-bold">OFF</span>}
                        label="No Scenery"
                    />
                    <ModeButton
                        active={environment.scenery === 'city'}
                        onClick={() => updateEnvironment({ scenery: 'city' })}
                        icon={<span className="text-[10px] font-bold">CITY</span>}
                        label="City Environment"
                    />
                    <ModeButton
                        active={environment.scenery === 'nature'}
                        onClick={() => updateEnvironment({ scenery: 'nature' })}
                        icon={<span className="text-[10px] font-bold">NAT</span>}
                        label="Nature Environment"
                    />
                    <ModeButton
                        active={environment.scenery === 'studio'}
                        onClick={() => updateEnvironment({ scenery: 'studio' })}
                        icon={<span className="text-[10px] font-bold">STD</span>}
                        label="Studio Environment"
                    />
                </div>
            </Panel>
        </div>
    );
}

function ModeButton({ active, onClick, icon, label }: { active: boolean, onClick: () => void, icon: React.ReactNode, label: string }) {
    return (
        <Tooltip content={label}>
            <Button
                onClick={onClick}
                className={cn(
                    "p-2 transition-colors",
                    active ? "bg-zinc-800 text-white" : "text-zinc-500 hover:text-zinc-300"
                )}
            >
                {icon}
            </Button>
        </Tooltip>
    );
}
