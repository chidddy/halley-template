#include "game.h"
#include "game_stage.h"

void initOpenGLPlugin(IPluginRegistry &registry);
void initSDLSystemPlugin(IPluginRegistry &registry, std::optional<String> cryptKey);
void initSDLAudioPlugin(IPluginRegistry &registry);
void initSDLInputPlugin(IPluginRegistry &registry);
void initDX11Plugin(IPluginRegistry &registry);
void initAsioPlugin(IPluginRegistry &registry);

void HalleyGame::init(const Environment& env, const Vector<String>& args)
{
}

int HalleyGame::initPlugins(IPluginRegistry& registry)
{
	initOpenGLPlugin(registry);
	initSDLSystemPlugin(registry, {});
	initSDLAudioPlugin(registry);
	initSDLInputPlugin(registry);

#ifdef WITH_DX11
	initDX11Plugin(registry);
#endif
#ifdef WITH_ASIO
	initAsioPlugin(registry);
#endif

	return HalleyAPIFlags::Video | HalleyAPIFlags::Audio | HalleyAPIFlags::Input | HalleyAPIFlags::Network | HalleyAPIFlags::Platform;
}

ResourceOptions HalleyGame::initResourceLocator(const Path& gamePath, const Path& assetsPath, const Path& unpackedAssetsPath, ResourceLocator& locator) {
	constexpr bool localAssets = false;
	if (localAssets) {
		locator.addFileSystem(unpackedAssetsPath);
	} else {
		// other .dat files you may need:
		// music.dat (importing bg music)
		// sfx.dat (importing quick sfx)
		// movie.dat (importing video cutscenes)
		const String packs[] = { "images.dat", "shaders.dat", "config.dat" };
		for (auto& pack: packs) {
			locator.addPack(Path(assetsPath) / pack);
		}
	}
	return {};
}

String HalleyGame::getName() const
{
	return "Halley Blank Project";
}

String HalleyGame::getDataPath() const
{
	return "Halley/HalleyBlankProject";
}

bool HalleyGame::isDevMode() const
{
	return true;
}

std::unique_ptr<Stage> HalleyGame::startGame()
{
	bool vsync = true;

	getAPI().video->setWindow(WindowDefinition(WindowType::Window, Vector2i(1280, 720), getName()));
	getAPI().video->setVsync(vsync);
	getAPI().audio->startPlayback();
	return std::make_unique<GameStage>();
}

HalleyGame(HalleyGame);
