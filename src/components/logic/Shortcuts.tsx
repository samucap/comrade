import { useEffect } from 'react';
import useStore from '../../store/useStore';

export function Shortcuts() {
    useEffect(() => {
        const handleKeyDown = (e: KeyboardEvent) => {
            if ((e.metaKey || e.ctrlKey) && e.key === 'z') {
                e.preventDefault();
                if (e.shiftKey) {
                    useStore.temporal.getState().redo();
                } else {
                    useStore.temporal.getState().undo();
                }
            }
        };

        window.addEventListener('keydown', handleKeyDown);
        return () => window.removeEventListener('keydown', handleKeyDown);
    }, []);

    return null;
}
