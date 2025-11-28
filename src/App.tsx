import { Viewport } from './components/canvas/Viewport';
import { Header } from './components/overlay/Header';
import { Inspector } from './components/overlay/Inspector';
import { Shortcuts } from './components/logic/Shortcuts';
import { Sidebar } from './components/layout/Sidebar';
import { AssetGrid } from './components/workspace/AssetGrid';
import { TextTo3D } from './components/generation/TextTo3D';
import { ImageTo3D } from './components/generation/ImageTo3D';
import { ViewportToolbar } from './components/canvas/ViewportToolbar';
import { RiggingPanel } from './components/rigging/RiggingPanel';
import { AnimationPanel } from './components/animation/AnimationPanel';
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
        {currentView === 'workspace' && <AssetGrid />}
        {currentView === 'text-to-3d' && <TextTo3D />}
        {currentView === 'image-to-3d' && <ImageTo3D />}
        {currentView === 'rigging' && <RiggingPanel />}
        {currentView === 'animation' && <AnimationPanel />}

        {currentView === 'editor' && (
          <>
            {/* 3D Viewport Layer */}
            <div className="absolute inset-0 z-0">
              <Viewport />
            </div>

            {/* UI Overlay Layer */}
            <div className="absolute inset-0 z-10 pointer-events-none">
              {/* Header */}
              <Header />

              {/* Viewport Toolbar */}
              <ViewportToolbar />

              {/* Inspector */}
              <Inspector />
            </div>
          </>
        )}
      </main>
    </div>
  );
}

export default App;
