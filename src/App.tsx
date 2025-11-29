import { Viewport } from './components/canvas/Viewport';
import { Header } from './components/overlay/Header';

import { Shortcuts } from './components/logic/Shortcuts';
import { Sidebar } from './components/layout/Sidebar';
import { AssetGrid } from './components/workspace/AssetGrid';
import { TextTo3D } from './components/generation/TextTo3D';
import { ImageTo3D } from './components/generation/ImageTo3D';
import { ViewportControls } from './components/canvas/ViewportControls';
import { ViewportActions } from './components/canvas/ViewportActions';
import { EditorLayout } from './components/layout/EditorLayout';
import { MiniMap } from './components/canvas/MiniMap';
import useStore from './store/useStore';
import { Box, Image as ImageIcon, MessageSquare, Printer, Search } from 'lucide-react';
import { cn } from './lib/utils';

function App() {
  const currentView = useStore((state) => state.currentView);
  const setView = useStore((state) => state.setView);

  return (
    <div className="relative w-screen h-screen overflow-hidden bg-black text-zinc-200 font-sans flex">
      <Shortcuts />

      {/* Sidebar Navigation */}
      <Sidebar />

      {/* Main Content Area */}
      <main className="flex-1 relative h-full flex flex-col min-w-0">

        {/* Top Toolbar (Meshy Style) - Only show in generation/library views */}
        {currentView !== 'editor' && (
          <div className="h-14 border-b border-zinc-800 bg-[#09090b] flex items-center px-4 gap-2 flex-shrink-0">
            <ToolTab
              active={currentView === 'image-gen'}
              onClick={() => setView('image-gen')}
              label="Image to 3D"
              icon={<ImageIcon className="w-4 h-4" />}
            />
            <ToolTab
              active={currentView === 'model-gen'}
              onClick={() => setView('model-gen')}
              label="Text to 3D"
              icon={<Box className="w-4 h-4" />}
            />
            <ToolTab
              label="Chat to 3D"
              icon={<MessageSquare className="w-4 h-4" />}
              badge="New"
            />
            <ToolTab
              label="Aether Print"
              icon={<Printer className="w-4 h-4" />}
            />

            <div className="ml-auto flex items-center gap-2">
              <div className="relative">
                <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500" />
                <input
                  type="text"
                  placeholder="Search assets..."
                  className="bg-zinc-900 border border-zinc-800 rounded-lg pl-9 pr-4 py-1.5 text-sm text-zinc-300 focus:outline-none focus:border-zinc-700 w-64"
                />
              </div>
              <button className="px-3 py-1.5 rounded-lg bg-zinc-900 border border-zinc-800 text-sm text-zinc-300 hover:text-white">
                What's new
              </button>
            </div>
          </div>
        )}

        <div className="flex-1 relative overflow-hidden">
          {currentView === 'library' && <AssetGrid />}
          {currentView === 'image-gen' && <ImageTo3D />}
          {currentView === 'model-gen' && <TextTo3D />}

          {currentView === 'editor' && (
            <div className="flex w-full h-full">
              {/* 3D Viewport Area */}
              <div className="flex-1 relative">
                <div className="absolute inset-0 z-0">
                  <Viewport />
                </div>

                <div className="absolute inset-0 z-10 pointer-events-none">
                  <Header />
                  <Header />
                  <ViewportControls />
                  <ViewportActions />
                  <MiniMap />
                </div>
              </div>

              {/* Right Panel */}
              <EditorLayout />
            </div>
          )}
        </div>
      </main>
    </div>
  );
}

function ToolTab({ label, icon, active, onClick, badge }: { label: string, icon: React.ReactNode, active?: boolean, onClick?: () => void, badge?: string }) {
  return (
    <button
      onClick={onClick}
      className={cn(
        "flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all relative",
        active
          ? "bg-zinc-800 text-white shadow-sm"
          : "text-zinc-400 hover:bg-zinc-900 hover:text-zinc-200"
      )}
    >
      {icon}
      <span>{label}</span>
      {badge && (
        <span className="absolute -top-1 -right-1 px-1.5 py-0.5 bg-purple-500 text-[8px] font-bold text-white rounded-full">
          {badge}
        </span>
      )}
    </button>
  );
}

export default App;
