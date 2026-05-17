import { useEffect, useMemo, useState } from 'react';
import Lottie from 'lottie-react';
import { Network } from 'lucide-react';

import familyTreeLoadingIn from '../../assets/lottie/family-tree-loading-in.json';
import familyRelationshipBuilding from '../../assets/lottie/family-relationship-building.json';
import familyTreeLoadingOut from '../../assets/lottie/family-tree-loading-out.json';
import loadingLoopAnimation from '../../assets/lottie/Loading loop animation.json';
import treeGrowthNoBackground from '../../assets/lottie/tree growth without background.json';
import treeAnimation from '../../assets/lottie/tree.json';

const animations = {
  login_tree: treeAnimation,
  tree_in: loadingLoopAnimation || treeGrowthNoBackground || familyTreeLoadingIn,
  relationships: loadingLoopAnimation || treeGrowthNoBackground || familyRelationshipBuilding,
  tree_out: loadingLoopAnimation || familyTreeLoadingOut,
};

export function LoadingCard({
  fullScreen = true,
  messages = [],
  title = 'Preparing your family view...',
  variant = 'tree_in',
  mode = 'bare',
  sequence = false,
}) {
  const [messageIndex, setMessageIndex] = useState(0);

  const activeMessages = useMemo(
    () => (messages.length > 0 ? messages : [title]),
    [messages, title],
  );

  useEffect(() => {
    if (activeMessages.length <= 1) {
      return undefined;
    }

    const timer = setInterval(() => {
      setMessageIndex((current) => {
        if (sequence) {
          return Math.min(current + 1, activeMessages.length - 1);
        }

        return (current + 1) % activeMessages.length;
      });
    }, 2200);

    return () => clearInterval(timer);
  }, [activeMessages]);

  const animationData = animations[variant] || animations.tree_in;

  return (
    <section
      className={[
        fullScreen ? 'loading-screen loading-screen-full' : 'loading-screen',
        mode === 'bare' ? 'loading-screen-bare' : '',
      ].filter(Boolean).join(' ')}
      aria-live="polite"
      aria-busy="true"
    >
      <div className="loading-screen-backdrop" />
      <div className="loading-screen-core">
        <div className="loading-lottie-box" aria-hidden="true">
          <div className="loading-lottie-wrap loading-lottie-login-tree">
          {animationData ? (
            <Lottie animationData={animationData} autoplay loop />
          ) : (
            <div className="loading-fallback-icon">
              <Network size={40} />
            </div>
          )}
          </div>
        </div>
        <p className="loading-screen-text">{activeMessages[messageIndex]}</p>
      </div>
    </section>
  );
}
