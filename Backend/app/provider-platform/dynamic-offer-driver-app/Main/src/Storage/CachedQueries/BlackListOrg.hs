{-
 Copyright 2022-23, Juspay India Pvt Ltd

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License

 as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program

 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY

 or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details. You should have received a copy of

 the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
-}
{-# OPTIONS_GHC -Wno-deprecations #-}

module Storage.CachedQueries.BlackListOrg
  ( findBySubscriberIdAndDomain,
    findBySubscriberIdDomainMerchantIdAndMerchantOperatingCityId,
  )
where

import Data.Coerce (coerce)
import Domain.Types.BlackListOrg
import Domain.Types.Common
import Domain.Types.Merchant hiding (Subscriber)
import Domain.Types.MerchantOperatingCity
import Kernel.Prelude
import qualified Kernel.Storage.Hedis as Hedis
import Kernel.Types.Beckn.Domain (Domain (..))
import Kernel.Types.Id
import Kernel.Types.Registry (Subscriber)
import Kernel.Utils.Common
import qualified Storage.Queries.BlackListOrg as Queries

findBySubscriberIdAndDomain :: (CacheFlow m r, EsqDBFlow m r) => ShortId Subscriber -> Domain -> m (Maybe BlackListOrg)
findBySubscriberIdAndDomain subscriberId domain =
  Hedis.safeGet (makeShortIdKey subscriberId domain) >>= \case
    Just a -> return . Just $ coerce @(BlackListOrgD 'Unsafe) @BlackListOrg a
    Nothing -> findAndCache
  where
    findAndCache = flip whenJust cacheOrganization /=<< Queries.findBySubscriberIdAndDomain subscriberId domain

cacheOrganization :: (CacheFlow m r) => BlackListOrg -> m ()
cacheOrganization org = do
  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
  Hedis.setExp (makeShortIdKey org.subscriberId org.domain) (coerce @BlackListOrg @(BlackListOrgD 'Unsafe) org) expTime

makeShortIdKey :: ShortId Subscriber -> Domain -> Text
makeShortIdKey subscriberId domain = "CachedQueries:BlackListOrg:SubscriberId-" <> subscriberId.getShortId <> "-Domain-" <> show domain

findBySubscriberIdDomainMerchantIdAndMerchantOperatingCityId :: (CacheFlow m r, EsqDBFlow m r) => ShortId Subscriber -> Domain -> Id Merchant -> Id MerchantOperatingCity -> m (Maybe BlackListOrg)
findBySubscriberIdDomainMerchantIdAndMerchantOperatingCityId subscriberId domain merchantId merchantOperatingCityId =
  Hedis.safeGet (makeConfigKey subscriberId domain merchantId merchantOperatingCityId) >>= \case
    Just a -> return . Just $ coerce @(BlackListOrgD 'Unsafe) @BlackListOrg a
    Nothing -> findAndCacheWithMerchantAndCityId
  where
    findAndCacheWithMerchantAndCityId = flip whenJust cacheOrganizationWithMerchantIdAndOperatingCityId /=<< Queries.findBySubscriberIdDomainMerchantIdAndMerchantOperatingCityId subscriberId domain merchantId merchantOperatingCityId

cacheOrganizationWithMerchantIdAndOperatingCityId :: (CacheFlow m r) => BlackListOrg -> m ()
cacheOrganizationWithMerchantIdAndOperatingCityId org = do
  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
  Hedis.setExp (makeConfigKey org.subscriberId org.domain org.merchantId org.merchantOperatingCityId) (coerce @BlackListOrg @(BlackListOrgD 'Unsafe) org) expTime

makeConfigKey :: ShortId Subscriber -> Domain -> Id Merchant -> Id MerchantOperatingCity -> Text
makeConfigKey subscriberId domain merchantId merchantOperatingCityId = "CachedQueries:BlackListOrg:SubscriberId-" <> subscriberId.getShortId <> "-Domain-" <> show domain <> "-MerchantId-" <> merchantId.getId <> "-MerchantOperatingCityId-" <> merchantOperatingCityId.getId
