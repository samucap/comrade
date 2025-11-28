import { cn } from "../../lib/utils";

interface PanelProps extends React.HTMLAttributes<HTMLDivElement> { }

export function Panel({ className, children, ...props }: PanelProps) {
    return (
        <div
            className={cn(
                "bg-black/80 backdrop-blur-md border border-white/10",
                className
            )}
            {...props}
        >
            {children}
        </div>
    );
}
