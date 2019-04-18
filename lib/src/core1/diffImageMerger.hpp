// Copyright (c) 2012-2017 VideoStitch SAS
// Copyright (c) 2018 stitchEm

#pragma once

#include "imageMerger.hpp"

#include "libvideostitch/imageMergerFactory.hpp"

namespace VideoStitch {
namespace Core {

/**
 * @brief Diff image merger.
 * A merger that helps visualizing the stitching errors.
 */
class DiffImageMerger : public ImageMerger {
 public:
  /**
   * @brief DiffImageMerger factory.
   */
  class Factory : public ImageMergerFactory {
   public:
    virtual Potential<ImageMerger> create(const PanoDefinition& pano, ImageMapping& fromIm, const ImageMerger* to,
                                          bool) const;
    virtual ~Factory() {}
    Ptv::Value* serialize() const;
    virtual CoreVersion version() const { return CoreVersion1; }
    virtual ImageMergerFactory* clone() const;
    virtual std::string hash() const;
  };

 public:
  ~DiffImageMerger();

  Status mergeAsync(TextureTarget, const PanoDefinition&, GPU::Buffer<uint32_t> pbo, GPU::UniqueBuffer<uint32_t>&,
                    const ImageMapping&, bool isFirstMerger, GPU::Stream) const override;
  Status reconstruct(TextureTarget, const PanoDefinition& pano, GPU::Buffer<uint32_t> panoDevOut, bool,
                     GPU::Stream stream) const override;

 private:
  DiffImageMerger(const PanoDefinition& pano, ImageMapping& fromIm, const ImageMerger* to);
};
}  // namespace Core
}  // namespace VideoStitch
