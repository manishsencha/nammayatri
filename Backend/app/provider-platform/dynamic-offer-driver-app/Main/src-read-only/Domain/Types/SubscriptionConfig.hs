{-# LANGUAGE ApplicativeDo #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Domain.Types.SubscriptionConfig where

import Data.Aeson
import qualified Data.Time
import qualified Domain.Types.Merchant
import qualified Domain.Types.MerchantMessage
import qualified Domain.Types.MerchantOperatingCity
import qualified Domain.Types.MerchantServiceConfig
import qualified Domain.Types.Plan
import qualified Domain.Types.VehicleCategory
import Kernel.Prelude
import qualified Kernel.Types.Common
import qualified Kernel.Types.Id
import qualified Tools.Beam.UtilsTH

data SubscriptionConfig = SubscriptionConfig
  { allowDriverFeeCalcSchedule :: Kernel.Prelude.Bool,
    allowDueAddition :: Kernel.Prelude.Bool,
    allowManualPaymentLinks :: Kernel.Prelude.Bool,
    cgstPercentageOneTimeSecurityDeposit :: Kernel.Prelude.Maybe Kernel.Types.Common.HighPrecMoney,
    deepLinkExpiryTimeInMinutes :: Kernel.Prelude.Maybe Kernel.Prelude.Int,
    defaultCityVehicleCategory :: Domain.Types.VehicleCategory.VehicleCategory,
    enableCityBasedFeeSwitch :: Kernel.Prelude.Bool,
    executionEnabledForVehicleCategories :: Kernel.Prelude.Maybe [Domain.Types.VehicleCategory.VehicleCategory],
    freeTrialRidesApplicable :: Kernel.Prelude.Bool,
    genericBatchSizeForJobs :: Kernel.Prelude.Int,
    genericJobRescheduleTime :: Data.Time.NominalDiffTime,
    isSubscriptionEnabledAtCategoryLevel :: Kernel.Prelude.Bool,
    isTriggeredAtEndRide :: Kernel.Prelude.Bool,
    isVendorSplitEnabled :: Kernel.Prelude.Maybe Kernel.Prelude.Bool,
    maxRetryCount :: Kernel.Prelude.Int,
    numberOfFreeTrialRides :: Kernel.Prelude.Maybe Kernel.Prelude.Int,
    partialDueClearanceMessageKey :: Kernel.Prelude.Maybe Domain.Types.MerchantMessage.MessageKey,
    paymentLinkChannel :: Domain.Types.MerchantMessage.MediaChannel,
    paymentLinkJobTime :: Data.Time.NominalDiffTime,
    paymentServiceName :: Domain.Types.MerchantServiceConfig.ServiceName,
    payoutServiceName :: Kernel.Prelude.Maybe Domain.Types.MerchantServiceConfig.ServiceName,
    sendDeepLink :: Kernel.Prelude.Bool,
    sendInAppFcmNotifications :: Kernel.Prelude.Bool,
    serviceName :: Domain.Types.Plan.ServiceNames,
    sgstPercentageOneTimeSecurityDeposit :: Kernel.Prelude.Maybe Kernel.Types.Common.HighPrecMoney,
    subscriptionDown :: Kernel.Prelude.Maybe Kernel.Prelude.Bool,
    subscriptionEnabledForVehicleCategories :: Kernel.Prelude.Maybe [Domain.Types.VehicleCategory.VehicleCategory],
    useOverlayService :: Kernel.Prelude.Bool,
    merchantId :: Kernel.Prelude.Maybe (Kernel.Types.Id.Id Domain.Types.Merchant.Merchant),
    merchantOperatingCityId :: Kernel.Prelude.Maybe (Kernel.Types.Id.Id Domain.Types.MerchantOperatingCity.MerchantOperatingCity),
    createdAt :: Kernel.Prelude.UTCTime,
    updatedAt :: Kernel.Prelude.UTCTime
  }
  deriving (Generic, Show, ToJSON, FromJSON)
