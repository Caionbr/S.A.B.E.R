/* Reproduz ECG (5 min) a 360 Hz em DAC1_OUT1 (PA4) por IRQ */
#include "main.h"
#include <stdint.h>
#include "ecg_5min.h"   /* coloque ecg_5min.h na mesma pasta do main.c, ou em um path incluído */

DAC_HandleTypeDef hdac1;
TIM_HandleTypeDef htim6;

/* índice da amostra atual e valor default (meia-escala) */
static volatile uint32_t play_idx = 0;
static uint16_t last_sample = 2048;

/* Protótipos */
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DAC1_Init(void);
static void MX_TIM6_Init(void);

/* A cada “tic” do TIM6 (~360 Hz), manda a próxima amostra pro DAC */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  if (htim->Instance == TIM6) {
    uint16_t s = last_sample;
    if (ECG5MIN_NSAMPLES > 0U) {
      s = ecg5min[play_idx++];
      if (play_idx >= ECG5MIN_NSAMPLES) play_idx = 0;  /* loop */
      last_sample = s;
    }
    HAL_DAC_SetValue(&hdac1, DAC_CHANNEL_1, DAC_ALIGN_12B_R, s);
  }
}

int main(void)
{
  HAL_Init();
  SystemClock_Config();

  MX_GPIO_Init();   /* configura PA4 como analógico */
  MX_DAC1_Init();   /* liga clock do DAC e configura CH1 */
  MX_TIM6_Init();   /* ~360 Hz + NVIC */

  /* TESTE: force 2048 antes do timer — se PA4 estiver ok você mede ~1,65 V*/
  HAL_DAC_Start(&hdac1, DAC_CHANNEL_1);
  HAL_DAC_SetValue(&hdac1, DAC_CHANNEL_1, DAC_ALIGN_12B_R, 2048);

  /* inicia temporizador com interrupção (passa a tocar o array) */
  HAL_TIM_Base_Start_IT(&htim6);

  while (1) { /* tudo acontece na IRQ */ }
}

/* ===== Clock: HSI 8 MHz, sem PLL ===== */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  RCC_OscInitStruct.OscillatorType      = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState            = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState        = RCC_PLL_NONE;
  HAL_RCC_OscConfig(&RCC_OscInitStruct);

  RCC_ClkInitStruct.ClockType      = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                                   |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource   = RCC_SYSCLKSOURCE_HSI;
  RCC_ClkInitStruct.AHBCLKDivider  = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;
  HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_0);
}

/* ===== GPIO: PA4 como ANALOG (DAC OUT1) ===== */
static void MX_GPIO_Init(void)
{
  __HAL_RCC_GPIOA_CLK_ENABLE();

  GPIO_InitTypeDef g = {0};
  g.Pin  = GPIO_PIN_4;              /* PA4 */
  g.Mode = GPIO_MODE_ANALOG;        /* *** IMPORTANTE *** */
  g.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOA, &g);
}

/* ===== DAC1 CH1 (PA4), trigger NONE ===== */
static void MX_DAC1_Init(void)
{
  __HAL_RCC_DAC1_CLK_ENABLE();      /* *** IMPORTANTE: liga clock do DAC *** */

  DAC_ChannelConfTypeDef sConfig = {0};
  hdac1.Instance = DAC1;
  HAL_DAC_Init(&hdac1);

  sConfig.DAC_Trigger      = DAC_TRIGGER_NONE;     /* vamos escrever na IRQ do TIM6 */
  sConfig.DAC_OutputBuffer = DAC_OUTPUTBUFFER_ENABLE;
  HAL_DAC_ConfigChannel(&hdac1, &sConfig, DAC_CHANNEL_1);
}

/* ===== TIM6 ≈ 360 Hz =====
 * 8 MHz/(PSC+1)=100 kHz com PSC=79
 * f = 100000 / (ARR+1)
 * ARR=277 → ~359,712 Hz (erro ~0,08%)
 */
static void MX_TIM6_Init(void)
{
  __HAL_RCC_TIM6_CLK_ENABLE();

  htim6.Instance               = TIM6;
  htim6.Init.Prescaler         = 79;
  htim6.Init.CounterMode       = TIM_COUNTERMODE_UP;
  htim6.Init.Period            = 277;
  htim6.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  HAL_TIM_Base_Init(&htim6);

  /* NVIC — garante que a IRQ está habilitada */
  HAL_NVIC_SetPriority(TIM6_DAC_IRQn, 1, 0);
  HAL_NVIC_EnableIRQ(TIM6_DAC_IRQn);
}

/* Error handler padrão */
void Error_Handler(void)
{
  __disable_irq();
  while (1) { }
}
