// Copyright (c) 2012-2017 VideoStitch SAS
// Copyright (c) 2018 stitchEm

#include "magewell_reader.hpp"
#include "magewell_discovery.hpp"
#include "export.hpp"

#include "libgpudiscovery/delayLoad.hpp"

#ifdef DELAY_LOAD_ENABLED
SET_DELAY_LOAD_HOOK
#endif  // DELAY_LOAD_ENABLED

extern "C" VS_PLUGINS_EXPORT VideoStitch::Potential<VideoStitch::Input::Reader>* __cdecl createReaderFn(
    const VideoStitch::Ptv::Value* config, VideoStitch::Plugin::VSReaderPlugin::Config runtime) {
  VideoStitch::Input::MagewellReader* magewell =
      VideoStitch::Input::MagewellReader::create(runtime.id, config, runtime.width, runtime.height);
  if (magewell) {
    return new VideoStitch::Potential<VideoStitch::Input::Reader>(magewell);
  }
  return new VideoStitch::Potential<VideoStitch::Input::Reader>(
      VideoStitch::Origin::Input, VideoStitch::ErrType::InvalidConfiguration, "Could not create Magewell reader");
}

extern "C" VS_PLUGINS_EXPORT bool __cdecl handleReaderFn(const VideoStitch::Ptv::Value* config) {
  return VideoStitch::Input::MagewellReader::handles(config);
}

extern "C" VS_PLUGINS_EXPORT VideoStitch::Plugin::VSDiscoveryPlugin* __cdecl discoverFn() {
  return VideoStitch::Plugin::MagewellDiscovery::create();
}
