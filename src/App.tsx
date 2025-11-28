import { Viewport } from './components/canvas/Viewport';
import { Header } from './components/overlay/Header';

import { Shortcuts } from './components/logic/Shortcuts';
import { Sidebar } from './components/layout/Sidebar';
import { AssetGrid } from './components/workspace/AssetGrid';
import { TextTo3D } from './components/generation/TextTo3D';
import { ImageTo3D } from './components/generation/ImageTo3D';
import { ViewportToolbar } from './components/canvas/ViewportToolbar';
import { EditorLayout } from './components/layout/EditorLayout';
import { MiniMap } from './components/canvas/MiniMap';
import useStore from './store/useStore';

function App() {
  const currentView = useStore((state) => state.currentView);

  return (
    <div className="relative w-screen h-screen overflow-hidden bg-black text-zinc-200 font-mono flex">
      <Shortcuts />

      {/* Sidebar Navigation */}
      <Sidebar />

      {/* Main Content Area */}
      <main className="flex-1 relative h-full">
        {currentView === 'library' && <AssetGrid />}
        {currentView === 'image-gen' && <ImageTo3D />} {/* Placeholder for Image Gen */}
        {currentView === 'model-gen' && <TextTo3D />} {/* Placeholder for Model Gen */}

        {currentView === 'editor' && (
          <div className="flex w-full h-full">
            {/* 3D Viewport Area */}
            <div className="flex-1 relative">
              <div className="absolute inset-0 z-0">
                <Viewport />
              </div>

              <div className="absolute inset-0 z-10 pointer-events-none">
                <Header />
                <ViewportToolbar />
                <MiniMap />
              </div>
            </div>

            {/* Right Panel */}
            <EditorLayout />
          </div>
        )}
      </main>
    </div>
  );
}

export default App;
