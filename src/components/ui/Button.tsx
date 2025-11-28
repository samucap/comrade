import { cn } from "../../lib/utils";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> { }

export function Button({ className, children, ...props }: ButtonProps) {
    return (
        <button
            className={cn(
                "px-4 py-2 text-sm font-medium transition-colors border border-zinc-800 bg-black text-zinc-200 hover:bg-white hover:text-black disabled:opacity-50 disabled:pointer-events-none",
                className
            )}
            {...props}
        >
            {children}
        </button>
    );
}
