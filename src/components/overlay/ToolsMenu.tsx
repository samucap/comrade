import {
    X,
    Scissors,
    Share2,
    Brush,
    Video,
    Package,
    Accessibility,
    MessageSquareCode,
    Lock
} from 'lucide-react';
import { cn } from '../../lib/utils';

interface ToolsMenuProps {
    isOpen: boolean;
    onClose: () => void;
}

export function ToolsMenu({ isOpen, onClose }: ToolsMenuProps) {
    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/50 backdrop-blur-sm" onClick={onClose}>
            <div
                className="w-[800px] bg-[#09090b] border border-zinc-800 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-200"
                onClick={(e) => e.stopPropagation()}
            >
                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-zinc-800">
                    <h2 className="text-lg font-bold text-white">Creative Tools</h2>
                    <button
                        onClick={onClose}
                        className="p-2 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded-lg transition-colors"
                    >
                        <X className="w-5 h-5" />
                    </button>
                </div>

                {/* Grid */}
                <div className="p-6 grid grid-cols-2 gap-4">
                    <ToolCard
                        icon={<Scissors className="w-6 h-6 text-emerald-400" />}
                        title="Segment Image"
                        description="Cut out objects, parts or backgrounds."
                        color="emerald"
                    />
                    <ToolCard
                        icon={<Share2 className="w-6 h-6 text-orange-400" />}
                        title="AI Retopology"
                        description="Simplify & retopologize meshes in a click."
                        color="orange"
                        locked
                    />
                    <ToolCard
                        icon={<Brush className="w-6 h-6 text-blue-400" />}
                        title="AI Retexture"
                        description="Retexture meshes, in seconds."
                        color="blue"
                        locked
                    />
                    <ToolCard
                        icon={<Video className="w-6 h-6 text-blue-500" />}
                        title="3D Video Studio"
                        description="Create 3D video scene."
                        color="blue"
                        locked
                    />
                    <ToolCard
                        icon={<Package className="w-6 h-6 text-purple-400" />}
                        title="Image to Kit"
                        description="Generate parts kit for better quality."
                        color="purple"
                        locked
                    />
                    <ToolCard
                        icon={<Accessibility className="w-6 h-6 text-pink-400" />}
                        title="AI Animate"
                        description="Rig and animate 3D meshes."
                        color="pink"
                        locked
                        badge="Experimental"
                    />
                    <ToolCard
                        icon={<MessageSquareCode className="w-6 h-6 text-purple-400" />}
                        title="Blender MCP"
                        description="Build animated worlds with text prompts."
                        color="purple"
                        badge="Experimental"
                    />
                </div>
            </div>
        </div>
    );
}

interface ToolCardProps {
    icon: React.ReactNode;
    title: string;
    description: string;
    color: 'emerald' | 'orange' | 'blue' | 'purple' | 'pink';
    locked?: boolean;
    badge?: string;
}

function ToolCard({ icon, title, description, color, locked, badge }: ToolCardProps) {
    const colorStyles = {
        emerald: "bg-emerald-500/10 border-emerald-500/20 hover:border-emerald-500/40",
        orange: "bg-orange-500/10 border-orange-500/20 hover:border-orange-500/40",
        blue: "bg-blue-500/10 border-blue-500/20 hover:border-blue-500/40",
        purple: "bg-purple-500/10 border-purple-500/20 hover:border-purple-500/40",
        pink: "bg-pink-500/10 border-pink-500/20 hover:border-pink-500/40",
    };

    const iconBgStyles = {
        emerald: "bg-emerald-500/20",
        orange: "bg-orange-500/20",
        blue: "bg-blue-500/20",
        purple: "bg-purple-500/20",
        pink: "bg-pink-500/20",
    };

    return (
        <button className={cn(
            "flex items-start gap-4 p-4 rounded-xl border text-left transition-all group relative overflow-hidden",
            colorStyles[color]
        )}>
            <div className={cn("p-3 rounded-lg flex-shrink-0", iconBgStyles[color])}>
                {icon}
            </div>
            <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                    <h3 className={cn("font-bold text-sm", `text-${color}-400`)}>{title}</h3>
                    {locked && <Lock className="w-3 h-3 text-zinc-500" />}
                    {badge && (
                        <span className="px-1.5 py-0.5 rounded text-[10px] font-bold bg-amber-500 text-black">
                            {badge}
                        </span>
                    )}
                </div>
                <p className="text-xs text-zinc-400 group-hover:text-zinc-300 transition-colors">
                    {description}
                </p>
            </div>
        </button>
    );
}
