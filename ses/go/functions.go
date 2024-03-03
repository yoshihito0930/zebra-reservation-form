package main

import (
	"context"
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

// Email はSESを利用してメールを送信する関数です
func Email(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// フォームデータを取得
	var data RequestData
	var err error
	if err != nil {
		log.Printf("Error unmarshalling request body: %v", err)
		return events.APIGatewayProxyResponse{Body: "Bad Request", StatusCode: 400}, nil
	}

	// SESクライアントのセットアップ
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Printf("Error loading AWS config: %v", err)
		return events.APIGatewayProxyResponse{Body: "Internal Server Error", StatusCode: 500}, nil
	}

	sesClient := ses.NewFromConfig(cfg)

	// メールの内容
	message := &types.Message{
		Subject: &types.Content{
			Data: aws.String("フォームが送信されました"),
		},
		Body: &types.Body{
			Text: &types.Content{
				Data: aws.String(fmt.Sprintf("フォームが送信されました\n\n%+v", data)),
			},
		},
	}

	// 送信元・送信先のメールアドレス
	source := "yoshihito.093079@gmail.com"
	destination := &types.Destination{
		ToAddresses: []string{"yoshihito.093079@gmail.com"},
	}

	// メール送信
	_, err = sesClient.SendEmail(ctx, &ses.SendEmailInput{
		Message:  message,
		Source:   &source,
		SourceArn: &source,
		Destination: destination,
	})
	if err != nil {
		log.Printf("Error sending email: %v", err)
		return events.APIGatewayProxyResponse{Body: "Internal Server Error", StatusCode: 500}, nil
	}

	return events.APIGatewayProxyResponse{Body: "Email sent successfully", StatusCode: 200}, nil
}