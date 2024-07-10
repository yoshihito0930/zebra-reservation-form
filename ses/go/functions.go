package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ses"
	"github.com/aws/aws-sdk-go-v2/service/ses/types"
)

// RequestData はフォームから受け取るデータの構造体です
type RequestData struct {
	Name               string `json:"name"`
	CompanyName        string `json:"companyName"`
	Email              string `json:"email"`
	PhoneNumber        string `json:"phoneNumber"`
	Address            string `json:"address"`
	PhotographerName   string `json:"photographerName"`
	Plan               bool   `json:"plan"`
	EquipmentInsurance bool   `json:"equipmentInsurance"`
	ReservationType    string `json:"reservationType"`
	PreferredDateTime  string `json:"preferredDateTime"`
	StealContent       string `json:"stealContent"`
	StealDetail        string `json:"stealDetail"`
	NumberOfPeople     string `json:"numberOfPeople"`
	HorizonProtection  string `json:"horizonProtection"`
	Others             string `json:"others"`
	TermsAndConditions bool   `json:"termsAndConditions"`
}

// AddCORSHeaders はレスポンスに CORS ヘッダーを追加するヘルパー関数です
func AddCORSHeaders(headers map[string]string) map[string]string {
	headers["Access-Control-Allow-Origin"] = "https://reservation-form.studiozebra-1st-dev.com" // すべてのオリジンからのアクセスを許可する場合
	headers["Access-Control-Allow-Methods"] = "OPTIONS, POST"
	headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
	return headers
}

// Email はSESを利用してメールを送信する関数です
func Email(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// CORS プリフライトリクエストへの対応
	if request.HTTPMethod == "OPTIONS" {
		headers := AddCORSHeaders(make(map[string]string))
		// レスポンスの構築
		response := events.APIGatewayProxyResponse{
			Headers:    headers,
			StatusCode: 200,
			Body:       "CORS Preflight Successful",
		}
		return response, nil
	}

	// リクエストボディを取得
	requestBody := request.Body

	// フォームデータを取得
	var data RequestData
	err := json.Unmarshal([]byte(requestBody), &data)
	if err != nil {
		log.Printf("Error unmarshalling request body: %v", err)
		return events.APIGatewayProxyResponse{Body: "Bad Request", StatusCode: 400}, nil
	}

	// リクエストボディをログに出力
	log.Printf("Received request body: %s", requestBody)

	// SESクライアントのセットアップ
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Printf("Error loading AWS config: %v", err)
		return events.APIGatewayProxyResponse{Body: "Internal Server Error", StatusCode: 500}, nil
	}

	sesClient := ses.NewFromConfig(cfg)

	// メールの内容を動的に変更
	var planText, equipmentInsuranceText, termsAndConditionsText string
	if data.Plan {
		planText = "機材使い放題"
	} else {
		planText = "機材使い放題ではない"
	}

	if data.EquipmentInsurance {
		equipmentInsuranceText = "機材保険あり"
	} else {
		equipmentInsuranceText = "機材保険なし"
	}

	if data.TermsAndConditions {
		termsAndConditionsText = "同意する"
	} else {
		termsAndConditionsText = "同意しない"
	}

	// メールの内容
	formattedBody := fmt.Sprintf(
		"氏名: %s\n"+
			"会社名: %s\n"+
			"メールアドレス: %s\n"+
			"電話番号: %s\n"+
			"住所: %s\n"+
			"カメラマン氏名: %s\n"+
			"ご利用プラン: %s\n"+
			"機材保険: %s\n"+
			"今回のご予約の種類: %s\n"+
			"ご希望の利用日時: %s\n"+
			"撮影内容: %s\n"+
			"撮影詳細: %s\n"+
			"ご利用人数: %s\n"+
			"ホリゾントの養生: %s\n"+
			"ロケハン希望、有料消耗品の利用希望、撮影内容についてのご相談など: %s\n"+
			"利用規約およびホリゾントルールのご確認: %s",
		data.Name,
		data.CompanyName,
		data.Email,
		data.PhoneNumber,
		data.Address,
		data.PhotographerName,
		planText,
		equipmentInsuranceText,
		data.ReservationType,
		data.PreferredDateTime,
		data.StealContent,
		data.StealDetail,
		data.NumberOfPeople,
		data.HorizonProtection,
		data.Others,
		termsAndConditionsText,
	)

	message := &types.Message{
		Subject: &types.Content{
			Data: aws.String(fmt.Sprintf("予約フォームから回答があります【%s】【%s】", data.ReservationType, data.PreferredDateTime)),
		},
		Body: &types.Body{
			Text: &types.Content{
				Data: aws.String(fmt.Sprintf("次の内容で、ご予約を希望されているお客様がいます。\n\n%s", formattedBody)),
			},
		},
	}

	// 送信元・送信先のメールアドレス
	source := "reservation-form@studiozebra-1st-dev.com"
	destination := &types.Destination{
		// ToAddresses: []string{"yoshihito.093079@gmail.com"},
		ToAddresses: []string{"studiozebra1st@gmail.com"},
	}

	// メール送信
	_, err = sesClient.SendEmail(ctx, &ses.SendEmailInput{
		Message:     message,
		Source:      &source,
		Destination: destination,
	})
	if err != nil {
		log.Printf("Error sending email: %v", err)
		return events.APIGatewayProxyResponse{Body: "Internal Server Error", StatusCode: 500}, nil
	}

	// CORSヘッダーの追加
	headers := AddCORSHeaders(make(map[string]string))

	// レスポンスの構築
	response := events.APIGatewayProxyResponse{
		Headers:    headers,
		StatusCode: 200,
		Body:       "Mail Sent Successful",
	}

	return response, nil
}
