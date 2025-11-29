import { Box } from 'lucide-react';
import { Panel } from '../ui/Panel';

export function Header() {
    return (
        <header className="absolute top-0 left-0 w-full p-4 flex justify-between items-center pointer-events-none z-50">
            <div className="flex gap-4 pointer-events-auto">
                <Panel className="px-4 py-2 flex items-center gap-4">
                    <div className="flex items-center gap-2">
                        <Box className="w-4 h-4 text-zinc-400" />
                        <h1 className="text-sm font-bold tracking-wider uppercase">Aerospace // Editor</h1>
                    </div>
                </Panel>
            </div>
        </header>
    );
}
