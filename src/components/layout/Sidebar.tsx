
import { useState } from 'react';
import {
    Box,
    LayoutGrid,
    Settings,
    User,
    Home,
    FolderPlus,
    ChevronLeft,
    ChevronRight,
    Library,
    Wand2,
    Hexagon
} from 'lucide-react';
import { cn } from '../../lib/utils';
import useStore from '../../store/useStore';
import { Tooltip } from '../ui/Tooltip';
import { ToolsMenu } from '../overlay/ToolsMenu';

export function Sidebar() {
    const currentView = useStore((state) => state.currentView);
    const setView = useStore((state) => state.setView);
    const [collapsed, setCollapsed] = useState(false);
    const [showTools, setShowTools] = useState(false);

    return (
        <>
            <aside
                className={cn(
                    "h-full bg-[#09090b] border-r border-zinc-800 flex flex-col transition-all duration-300 z-50",
                    collapsed ? "w-16" : "w-64"
                )}
            >
                {/* Header / Logo */}
                <div className="h-16 flex items-center px-4 border-b border-zinc-800">
                    <div className="w-8 h-8 bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 rounded-lg flex items-center justify-center flex-shrink-0 shadow-lg shadow-purple-500/20">
                        <Hexagon className="w-5 h-5 text-white fill-white/20" />
                    </div>
                    {!collapsed && (
                        <span className="ml-3 font-bold text-lg text-white tracking-tight">Aether</span>
                    )}
                    <button
                        onClick={() => setCollapsed(!collapsed)}
                        className="ml-auto p-1.5 text-zinc-500 hover:text-white rounded-md hover:bg-zinc-800 transition-colors"
                    >
                        {collapsed ? <ChevronRight className="w-4 h-4" /> : <ChevronLeft className="w-4 h-4" />}
                    </button>
                </div>

                {/* Main Navigation */}
                <nav className="flex-1 flex flex-col gap-1 p-3 overflow-y-auto">
                    <NavItem
                        icon={<Home className="w-5 h-5" />}
                        label="Home"
                        collapsed={collapsed}
                        active={currentView === 'home'} // Placeholder
                        onClick={() => setView('library')} // Map Home to Library for now
                    />
                    <NavItem
                        icon={<Library className="w-5 h-5" />}
                        label="My Assets"
                        collapsed={collapsed}
                        active={currentView === 'library'}
                        onClick={() => setView('library')}
                    />

                    <div className="my-2 border-t border-zinc-800" />

                    <div className={cn("px-3 py-2 text-xs font-medium text-zinc-500 uppercase", collapsed && "hidden")}>
                        Create
                    </div>

                    <NavItem
                        icon={<Box className="w-5 h-5" />}
                        label="Text to 3D"
                        collapsed={collapsed}
                        active={currentView === 'model-gen'}
                        onClick={() => setView('model-gen')}
                    />
                    <NavItem
                        icon={<LayoutGrid className="w-5 h-5" />}
                        label="Image to 3D"
                        collapsed={collapsed}
                        active={currentView === 'image-gen'}
                        onClick={() => setView('image-gen')}
                    />
                    <NavItem
                        icon={<Wand2 className="w-5 h-5 text-purple-400" />}
                        label="AI Tools"
                        collapsed={collapsed}
                        onClick={() => setShowTools(true)}
                    />

                    <div className="my-2 border-t border-zinc-800" />

                    <NavItem
                        icon={<FolderPlus className="w-5 h-5" />}
                        label="New Folder"
                        collapsed={collapsed}
                        onClick={() => { }} // Mock
                    />
                </nav>

                {/* Bottom Actions */}
                <div className="p-3 border-t border-zinc-800 flex flex-col gap-1">
                    <NavItem
                        icon={<Settings className="w-5 h-5" />}
                        label="Settings"
                        collapsed={collapsed}
                    />
                    <div className={cn(
                        "mt-2 p-3 rounded-xl bg-zinc-900 border border-zinc-800 flex items-center gap-3",
                        collapsed ? "justify-center p-2" : ""
                    )}>
                        <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-blue-500 to-purple-500 flex items-center justify-center flex-shrink-0">
                            <User className="w-4 h-4 text-white" />
                        </div>
                        {!collapsed && (
                            <div className="flex-1 min-w-0">
                                <div className="text-sm font-medium text-white truncate">User</div>
                                <div className="text-xs text-zinc-500 truncate">Free Plan</div>
                            </div>
                        )}
                    </div>
                </div>
            </aside>

            <ToolsMenu isOpen={showTools} onClose={() => setShowTools(false)} />
        </>
    );
}

function NavItem({ icon, label, collapsed, active, onClick }: { icon: React.ReactNode, label: string, collapsed: boolean, active?: boolean, onClick?: () => void }) {
    if (collapsed) {
        return (
            <Tooltip content={label} side="right">
                <button
                    onClick={onClick}
                    className={cn(
                        "w-full aspect-square flex items-center justify-center rounded-lg transition-all duration-200",
                        active
                            ? "bg-blue-600 text-white shadow-lg shadow-blue-900/20"
                            : "text-zinc-400 hover:bg-zinc-900 hover:text-zinc-200"
                    )}
                >
                    {icon}
                </button>
            </Tooltip>
        );
    }

    return (
        <button
            onClick={onClick}
            className={cn(
                "w-full flex items-center gap-3 px-3 py-2.5 rounded-lg transition-all duration-200 text-sm font-medium",
                active
                    ? "bg-zinc-900 text-white border border-zinc-800"
                    : "text-zinc-400 hover:bg-zinc-900/50 hover:text-zinc-200"
            )}
        >
            {icon}
            <span>{label}</span>
        </button>
    );
}
