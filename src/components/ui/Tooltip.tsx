import React, { useState } from 'react';
import { cn } from '../../lib/utils';

interface TooltipProps {
    content: string;
    children: React.ReactNode;
    side?: 'top' | 'bottom' | 'left' | 'right';
    className?: string;
}

export function Tooltip({ content, children, side = 'bottom', className }: TooltipProps) {
    const [isVisible, setIsVisible] = useState(false);

    return (
        <div
            className="relative flex items-center justify-center"
            onMouseEnter={() => setIsVisible(true)}
            onMouseLeave={() => setIsVisible(false)}
        >
            {children}
            {isVisible && (
                <div
                    className={cn(
                        "absolute z-50 px-2 py-1 text-xs text-white bg-zinc-900 border border-zinc-800 rounded shadow-lg whitespace-nowrap pointer-events-none",
                        side === 'top' && "bottom-full mb-2",
                        side === 'bottom' && "top-full mt-2",
                        side === 'left' && "right-full mr-2",
                        side === 'right' && "left-full ml-2",
                        className
                    )}
                >
                    {content}
                </div>
            )}
        </div>
    );
}
