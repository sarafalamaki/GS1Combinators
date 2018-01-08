{-# LANGUAGE OverloadedStrings #-}
module Tests.DWhy where

import           Test.Hspec
import qualified Data.Text as T
import           Data.GS1.EPC

testDisposition :: Spec
testDisposition =
  describe "Disposition" $ do
    describe "Print URI" $ do
      it "One word" $
        printURI Active `shouldBe` "urn:epcglobal:cbv:disp:active"
      it "Multiple words" $
        printURI ContainerClosed `shouldBe` "urn:epcglobal:cbv:disp:container_closed"

    describe "parse Disposition where invalid" $ do
      it "parse the valid uri to disposition" $
        readURI "urn:epcglobal:cbv:disp:active" `shouldBe` Right Active
      it "parses the invalid uri to Nothing" $
        (readURI :: T.Text -> Either ParseFailure Disposition)
          "urn:epcglobal:cbv:disp:active2"
            `shouldBe` Left InvalidFormat
      it "parse invalid string to Nothing" $
        (readURI :: T.Text -> Either ParseFailure Disposition)
          "somerandomstring"
            `shouldBe` Left InvalidFormat
      it "parse empty string to Nothing" $
        (readURI :: T.Text -> Either ParseFailure Disposition) ""
          `shouldBe` Left InvalidFormat
