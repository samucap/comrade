import { Box, LayoutGrid, Settings, User, Type, Image as ImageIcon } from 'lucide-react';
import { cn } from '../../lib/utils';
import useStore from '../../store/useStore';
import { Tooltip } from '../ui/Tooltip';

export function Sidebar() {
    const currentView = useStore((state) => state.currentView);
    const setView = useStore((state) => state.setView);

    return (
        <aside className="w-16 h-full bg-zinc-950 border-r border-zinc-900 flex flex-col items-center py-4 gap-4 z-50">
            {/* Logo */}
            <div className="w-10 h-10 bg-zinc-900 rounded-lg flex items-center justify-center mb-4">
                <Box className="w-6 h-6 text-white" />
            </div>

            {/* Navigation */}
            <nav className="flex flex-col gap-2 w-full px-2">
                <NavButton
                    icon={<ImageIcon className="w-5 h-5" />}
                    label="Image Gen"
                    active={currentView === 'image-gen'}
                    onClick={() => setView('image-gen')}
                />
                <NavButton
                    icon={<Box className="w-5 h-5" />}
                    label="3D Model Gen"
                    active={currentView === 'model-gen'}
                    onClick={() => setView('model-gen')}
                />

                <div className="w-full h-px bg-zinc-900 my-1" />

                <NavButton
                    icon={<LayoutGrid className="w-5 h-5" />}
                    label="Editor"
                    active={currentView === 'editor'}
                    onClick={() => setView('editor')}
                />

                <div className="w-full h-px bg-zinc-900 my-1" />

                <NavButton
                    icon={<Type className="w-5 h-5" />}
                    label="Library"
                    active={currentView === 'library'}
                    onClick={() => setView('library')}
                />
            </nav>

            <div className="flex-1" />

            {/* Bottom Actions */}
            <div className="flex flex-col gap-2 w-full px-2">
                <NavButton
                    icon={<Settings className="w-5 h-5" />}
                    label="Settings"
                />
                <div className="w-full h-px bg-zinc-900 my-1" />
                <NavButton
                    icon={<User className="w-5 h-5" />}
                    label="Profile"
                />
            </div>
        </aside>
    );
}

function NavButton({ icon, label, active, onClick }: { icon: React.ReactNode, label: string, active?: boolean, onClick?: () => void }) {
    return (
        <Tooltip content={label} side="right">
            <button
                onClick={onClick}
                className={cn(
                    "w-full aspect-square flex items-center justify-center rounded-md transition-all duration-200",
                    active
                        ? "bg-white text-black shadow-lg shadow-white/10"
                        : "text-zinc-500 hover:bg-zinc-900 hover:text-zinc-200"
                )}
            >
                {icon}
            </button>
        </Tooltip>
    );
}
