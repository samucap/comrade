import { useState, useRef } from 'react';
import { Plus, Box, Upload } from 'lucide-react';
import useStore from '../../store/useStore';
import { Panel } from '../ui/Panel';
import { Button } from '../ui/Button';
import { Input } from '../ui/Input';
import { Tooltip } from '../ui/Tooltip';

export function Header() {
    const addObject = useStore((state) => state.addObject);
    const [url, setUrl] = useState('');
    const fileInputRef = useRef<HTMLInputElement>(null);

    const handleAdd = () => {
        if (!url) return;
        // Simple name generation based on URL or random
        const name = url.split('/').pop()?.split('.')[0] || `Model_${Math.floor(Math.random() * 1000)}`;
        addObject(url, name);
        setUrl('');
    };

    const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;

        const objectUrl = URL.createObjectURL(file);
        const name = file.name.split('.')[0];
        addObject(objectUrl, name);

        // Reset input
        if (fileInputRef.current) {
            fileInputRef.current.value = '';
        }
    };

    return (
        <header className="absolute top-0 left-0 w-full p-4 flex justify-between items-center pointer-events-none z-50">
            <div className="flex gap-4 pointer-events-auto">
                <Panel className="px-4 py-2 flex items-center gap-4">
                    <div className="flex items-center gap-2">
                        <Box className="w-4 h-4 text-zinc-400" />
                        <h1 className="text-sm font-bold tracking-wider uppercase">Aerospace // Editor</h1>
                    </div>
                </Panel>

                <Panel className="p-1 flex items-center gap-2">
                    <Tooltip content="Enter URL to .glb or .gltf model">
                        <Input
                            placeholder="Model URL..."
                            value={url}
                            onChange={(e) => setUrl(e.target.value)}
                            className="w-64 border-none focus:ring-0"
                        />
                    </Tooltip>
                    <Tooltip content="Add Model from URL">
                        <Button onClick={handleAdd} disabled={!url} className="px-2 py-1">
                            <Plus className="w-4 h-4" />
                        </Button>
                    </Tooltip>

                    <div className="w-px h-6 bg-zinc-800 mx-1" />

                    <input
                        type="file"
                        ref={fileInputRef}
                        onChange={handleFileUpload}
                        accept=".glb,.gltf"
                        className="hidden"
                    />
                    <Tooltip content="Upload Local Model (.glb, .gltf)">
                        <Button onClick={() => fileInputRef.current?.click()} className="px-2 py-1">
                            <Upload className="w-4 h-4" />
                        </Button>
                    </Tooltip>
                </Panel>
            </div>
        </header>
    );
}
