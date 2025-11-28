import { useState } from 'react';
import { Inspector } from '../overlay/Inspector';
import { RiggingPanel } from '../rigging/RiggingPanel';
import { AnimationPanel } from '../animation/AnimationPanel';

import { Box, PersonStanding, Clapperboard, Download } from 'lucide-react';
import { Button } from '../ui/Button';

export function EditorLayout() {
    const [activeTab, setActiveTab] = useState('inspector');

    return (
        <div className="flex h-full">
            {/* Right Panel - Inspector/Rigging/Animation */}
            <div className="w-80 border-l border-zinc-800 bg-black flex flex-col">

                {/* Tab Navigation */}
                <div className="flex items-center border-b border-zinc-800">
                    <button
                        onClick={() => setActiveTab('inspector')}
                        className={`flex-1 p-3 flex justify-center items-center gap-2 text-xs font-bold uppercase tracking-wider transition-colors ${activeTab === 'inspector' ? 'text-blue-500 bg-zinc-900' : 'text-zinc-500 hover:text-zinc-300'}`}
                    >
                        <Box className="w-4 h-4" /> Inspector
                    </button>
                    <button
                        onClick={() => setActiveTab('rigging')}
                        className={`flex-1 p-3 flex justify-center items-center gap-2 text-xs font-bold uppercase tracking-wider transition-colors ${activeTab === 'rigging' ? 'text-blue-500 bg-zinc-900' : 'text-zinc-500 hover:text-zinc-300'}`}
                    >
                        <PersonStanding className="w-4 h-4" /> Rigging
                    </button>
                    <button
                        onClick={() => setActiveTab('animation')}
                        className={`flex-1 p-3 flex justify-center items-center gap-2 text-xs font-bold uppercase tracking-wider transition-colors ${activeTab === 'animation' ? 'text-blue-500 bg-zinc-900' : 'text-zinc-500 hover:text-zinc-300'}`}
                    >
                        <Clapperboard className="w-4 h-4" /> Animate
                    </button>
                </div>

                {/* Panel Content */}
                <div className="flex-1 overflow-y-auto">
                    {activeTab === 'inspector' && <Inspector />}
                    {activeTab === 'rigging' && <RiggingPanel />}
                    {activeTab === 'animation' && <AnimationPanel />}
                </div>

                {/* Footer Actions */}
                <div className="p-4 border-t border-zinc-800 bg-zinc-900/50">
                    <Button className="w-full bg-zinc-800 hover:bg-zinc-700 text-zinc-300 flex items-center justify-center gap-2">
                        <Download className="w-4 h-4" /> Export GLB
                    </Button>
                </div>

            </div>
        </div>
    );
}
