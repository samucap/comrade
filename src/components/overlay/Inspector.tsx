import { Panel } from '../ui/Panel';
import { Input } from '../ui/Input';
import { Button } from '../ui/Button';
import useStore from '../../store/useStore';
import type { Vector3Data } from '../../types/store';
import { Trash2, Move, Rotate3D, Scaling, Box, Layers } from 'lucide-react';
import { Tooltip } from '../ui/Tooltip';
import { cn } from '../../lib/utils';

export function Inspector() {
    const selectedId = useStore((state) => state.selectedId);
    const sceneObjects = useStore((state) => state.sceneObjects);
    const updateObjectTransform = useStore((state) => state.updateObjectTransform);
    const removeObject = useStore((state) => state.removeObject);
    const selectObject = useStore((state) => state.selectObject);
    const transformMode = useStore((state) => state.transformMode);
    const setTransformMode = useStore((state) => state.setTransformMode);

    const selectedObject = sceneObjects.find((obj) => obj.id === selectedId);

    const handleChange = (prop: 'position' | 'rotation' | 'scale', axis: 'x' | 'y' | 'z', value: string) => {
        if (!selectedObject) return;
        const numValue = parseFloat(value);
        if (isNaN(numValue)) return;

        const current = selectedObject[prop];
        updateObjectTransform(selectedObject.id, prop, { ...current, [axis]: numValue });
    };

    return (
        <aside className="absolute top-0 right-0 h-full w-80 p-4 pointer-events-auto flex flex-col gap-4">
            {/* Scene List Panel */}
            <Panel className="w-full flex-1 p-4 flex flex-col gap-4 min-h-0 overflow-hidden">
                <div className="flex items-center gap-2 border-b border-zinc-800 pb-2">
                    <Layers className="w-4 h-4 text-zinc-500" />
                    <h2 className="text-xs font-bold text-zinc-500 uppercase tracking-widest">
                        Scene Objects
                    </h2>
                </div>

                <div className="flex-1 overflow-y-auto flex flex-col gap-1 pr-2">
                    {sceneObjects.length === 0 ? (
                        <div className="text-xs text-zinc-600 italic p-2">No objects in scene</div>
                    ) : (
                        sceneObjects.map((obj) => (
                            <button
                                key={obj.id}
                                onClick={() => selectObject(obj.id)}
                                className={cn(
                                    "flex items-center gap-2 px-3 py-2 text-xs text-left rounded-sm transition-colors border border-transparent",
                                    selectedId === obj.id
                                        ? "bg-zinc-900 border-zinc-700 text-white"
                                        : "text-zinc-400 hover:bg-zinc-900/50 hover:text-zinc-200"
                                )}
                            >
                                <Box className="w-3 h-3 opacity-70" />
                                <span className="truncate">{obj.name}</span>
                            </button>
                        ))
                    )}
                </div>
            </Panel>

            {/* Properties Panel */}
            {selectedObject ? (
                <Panel className="w-full p-4 flex flex-col gap-6 shrink-0">
                    <div className="flex justify-between items-center border-b border-zinc-800 pb-2">
                        <h2 className="text-xs font-bold text-zinc-500 uppercase tracking-widest">
                            Properties
                        </h2>
                        <Tooltip content="Delete Object">
                            <Button
                                onClick={() => removeObject(selectedObject.id)}
                                className="p-1 h-auto text-red-500 hover:text-red-500 hover:bg-red-500/10 border-red-500/20"
                            >
                                <Trash2 className="w-4 h-4" />
                            </Button>
                        </Tooltip>
                    </div>

                    <div className="flex flex-col gap-2">
                        <label className="text-[10px] text-zinc-600 uppercase font-bold">Name</label>
                        <Input
                            value={selectedObject.name}
                            readOnly
                            className="bg-zinc-900/50 border-zinc-800 text-zinc-300"
                        />
                    </div>

                    {/* Transform Modes */}
                    <div className="flex gap-1 bg-zinc-900/50 p-1 rounded border border-zinc-800">
                        <Tooltip content="Translate (T)">
                            <Button
                                onClick={() => setTransformMode('translate')}
                                className={cn(
                                    "flex-1 justify-center border-none py-1",
                                    transformMode === 'translate' ? 'bg-zinc-700 text-white' : 'bg-transparent text-zinc-500 hover:bg-zinc-800'
                                )}
                            >
                                <Move className="w-4 h-4" />
                            </Button>
                        </Tooltip>
                        <Tooltip content="Rotate (R)">
                            <Button
                                onClick={() => setTransformMode('rotate')}
                                className={cn(
                                    "flex-1 justify-center border-none py-1",
                                    transformMode === 'rotate' ? 'bg-zinc-700 text-white' : 'bg-transparent text-zinc-500 hover:bg-zinc-800'
                                )}
                            >
                                <Rotate3D className="w-4 h-4" />
                            </Button>
                        </Tooltip>
                        <Tooltip content="Scale (S)">
                            <Button
                                onClick={() => setTransformMode('scale')}
                                className={cn(
                                    "flex-1 justify-center border-none py-1",
                                    transformMode === 'scale' ? 'bg-zinc-700 text-white' : 'bg-transparent text-zinc-500 hover:bg-zinc-800'
                                )}
                            >
                                <Scaling className="w-4 h-4" />
                            </Button>
                        </Tooltip>
                    </div>

                    <div className="flex flex-col gap-4">
                        <TransformGroup
                            label="Position"
                            data={selectedObject.position}
                            onChange={(axis, val) => handleChange('position', axis, val)}
                        />
                        <TransformGroup
                            label="Rotation"
                            data={selectedObject.rotation}
                            onChange={(axis, val) => handleChange('rotation', axis, val)}
                        />
                        <TransformGroup
                            label="Scale"
                            data={selectedObject.scale}
                            onChange={(axis, val) => handleChange('scale', axis, val)}
                        />
                    </div>
                </Panel>
            ) : (
                <Panel className="w-full p-4 shrink-0">
                    <div className="text-xs text-zinc-600 text-center py-4">
                        Select an object to edit properties
                    </div>
                </Panel>
            )}
        </aside>
    );
}

function TransformGroup({ label, data, onChange }: { label: string, data: Vector3Data, onChange: (axis: 'x' | 'y' | 'z', val: string) => void }) {
    return (
        <div className="flex flex-col gap-2">
            <label className="text-[10px] text-zinc-600 uppercase font-bold">{label}</label>
            <div className="grid grid-cols-3 gap-2">
                <AxisInput label="X" value={data.x} onChange={(v) => onChange('x', v)} />
                <AxisInput label="Y" value={data.y} onChange={(v) => onChange('y', v)} />
                <AxisInput label="Z" value={data.z} onChange={(v) => onChange('z', v)} />
            </div>
        </div>
    );
}

function AxisInput({ label, value, onChange }: { label: string, value: number, onChange: (val: string) => void }) {
    return (
        <div className="relative group">
            <div className="absolute left-2 top-1/2 -translate-y-1/2 text-[10px] text-zinc-500 font-bold pointer-events-none group-focus-within:text-white transition-colors">
                {label}
            </div>
            <Input
                value={value}
                onChange={(e) => onChange(e.target.value)}
                type="number"
                step={0.1}
                className="pl-6 text-right font-mono bg-zinc-900/30 focus:bg-zinc-900/80 border-zinc-800 focus:border-zinc-600"
            />
        </div>
    );
}
